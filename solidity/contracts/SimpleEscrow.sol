// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

contract SimpleEscrow is ReentrancyGuard {


    enum Status {
        AWAITING_DELIVERY,
        DISPUTED,
        COMPLETE,
        REFUNDED
    }

    struct Agreement {
        address buyer;
        address seller;
        address arbiter;
        uint256 amount;
        uint256 deadline;
        Status status;
    }


    mapping(uint256 => Agreement) public agreements;
    uint256 public nextId;


    event EscrowCreated(
        uint256 indexed id,
        address indexed buyer,
        address indexed seller,
        address arbiter,
        uint256 amount,
        uint256 deadline
    );
    event EscrowDisputed(uint256 indexed id);
    event FundReleased(uint256 indexed id, address indexed seller);
    event EscrowRefunded(uint256 indexed id, address indexed buyer);


    function createEscrow(
        address _seller,
        address _arbiter,
        uint256 _duration
    ) external payable returns (uint256) {

        require(msg.value > 0, "amount must be > 0");
        require(_duration > 0, "duration must be > 0");

        require(_seller != address(0), "seller is zero");
        require(_arbiter != address(0), "arbiter is zero");
        require(_seller != msg.sender, "seller == buyer");
        require(_arbiter != _seller, "arbiter == seller");
        require(_arbiter != msg.sender, "arbiter == buyer");

    
        uint256 id = nextId++;
        uint256 deadline = block.timestamp + _duration;

        agreements[id] = Agreement({
            buyer: msg.sender,
            seller: _seller,
            arbiter: _arbiter,
            amount: msg.value,
            deadline: deadline,
            status: Status.AWAITING_DELIVERY
        });

    
        emit EscrowCreated(id, msg.sender, _seller, _arbiter, msg.value, deadline);
        return id;
    }


    function releaseFunds(uint256 _id) external nonReentrant {
        require(_id < nextId, "escrow does not exist");
        Agreement storage a = agreements[_id];


        bool allowed =
            (msg.sender == a.buyer && a.status == Status.AWAITING_DELIVERY) ||
            (msg.sender == a.arbiter && a.status == Status.DISPUTED);
        require(allowed, "not authorized");

        a.status = Status.COMPLETE;

        (bool ok, ) = payable(a.seller).call{value: a.amount}("");
        require(ok, "transfer failed");

        emit FundReleased(_id, a.seller);
    }



    function dispute(uint256 _id) external {
        require(_id < nextId, "escrow does not exist");
        Agreement storage a = agreements[_id];

        require(msg.sender == a.buyer, "only buyer");
        require(a.status == Status.AWAITING_DELIVERY, "cannot dispute now");

        a.status = Status.DISPUTED;

        emit EscrowDisputed(_id);
    }


    function refundBuyer(uint256 _id) external nonReentrant {
        require(_id < nextId, "escrow does not exist");
        Agreement storage a = agreements[_id];

        require(msg.sender == a.arbiter, "only arbiter");
        require(a.status == Status.DISPUTED, "not disputed");

        a.status = Status.REFUNDED;

        (bool ok, ) = payable(a.buyer).call{value: a.amount}("");
        require(ok, "transfer failed");

        emit EscrowRefunded(_id, a.buyer);
    }



    function claimRefundAfterDeadline(uint256 _id) external nonReentrant {
        require(_id < nextId, "escrow does not exist");
        Agreement storage a = agreements[_id];

        require(msg.sender == a.buyer, "only buyer");
        require(a.status == Status.AWAITING_DELIVERY, "invalid status");
        require(block.timestamp >= a.deadline, "deadline not passed");

        a.status = Status.REFUNDED;

        (bool ok, ) = payable(a.buyer).call{value: a.amount}("");
        require(ok, "transfer failed");

        emit EscrowRefunded(_id, a.buyer);
    }
}