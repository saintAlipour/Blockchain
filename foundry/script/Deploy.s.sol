// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "forge-std/Script.sol";
import "../src/AzarsAuditLog.sol";

contract DeployAzarsAuditLog is Script {
    function run() external returns (AzarsAuditLog) {
        // خواندن کلید خصوصی از متغیر محیطی
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        address deployer = vm.addr(deployerPrivateKey);

        vm.startBroadcast(deployerPrivateKey);

        // Deploy قرارداد — deployer می‌شود owner اولیه
        AzarsAuditLog auditLog = new AzarsAuditLog(deployer);

        vm.stopBroadcast();

        console.log("AzarsAuditLog deployed at:", address(auditLog));
        console.log("Owner:", deployer);

        return auditLog;
    }
}