// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "forge-std/Test.sol";
import "../src/AzarsAuditLog.sol";

contract AzarsAuditLogTest is Test {
    AzarsAuditLog public auditLog;
    address public logger;
    address public attacker;

    function setUp() public {
        logger = address(0x1);
        attacker = address(0x2);

        // قرارداد تست (this) = owner
        auditLog = new AzarsAuditLog(address(this));
    }

    // ─── تست addLogger ───────────────────────────────
    function testOwnerCanAddLogger() public {
        auditLog.addLogger(logger);
        assertTrue(auditLog.authLoggers(logger));
    }

    function testNonOwnerCannotAddLogger() public {
        vm.prank(attacker);
        vm.expectRevert();
        auditLog.addLogger(logger);
    }

    // ─── تست removeLogger ────────────────────────────
    function testOwnerCanRemoveLogger() public {
        auditLog.addLogger(logger);
        auditLog.removeLogger(logger);
        assertFalse(auditLog.authLoggers(logger));
    }

    function testNonOwnerCannotRemoveLogger() public {
        auditLog.addLogger(logger);

        vm.prank(attacker);
        vm.expectRevert();
        auditLog.removeLogger(logger);
    }

    // ─── تست logTrade موفق ───────────────────────────
    function testLoggerCanLogBuy() public {
        auditLog.addLogger(logger);

        vm.prank(logger);
        auditLog.logTrade("AAPL", 150, "BUY", 1718000000);

        assertEq(auditLog.logCount(), 1);
    }

    function testLoggerCanLogSell() public {
        auditLog.addLogger(logger);

        vm.prank(logger);
        auditLog.logTrade("GOOGL", 2800, "SELL", 1718000100);

        assertEq(auditLog.logCount(), 1);
    }

    function testLogCountIncrements() public {
        auditLog.addLogger(logger);

        vm.prank(logger);
        auditLog.logTrade("AAPL", 150, "BUY", 1718000000);

        vm.prank(logger);
        auditLog.logTrade("GOOGL", 2800, "SELL", 1718000100);

        assertEq(auditLog.logCount(), 2);
    }

    // ─── تست logTrade ناموفق ─────────────────────────
    function testUnauthorizedCannotLogTrade() public {
        vm.prank(attacker);
        vm.expectRevert();
        auditLog.logTrade("AAPL", 150, "BUY", 1718000000);
    }

    function testEmptySymbolReverts() public {
        auditLog.addLogger(logger);

        vm.prank(logger);
        vm.expectRevert();
        auditLog.logTrade("", 150, "BUY", 1718000000);
    }

    function testInvalidSideReverts() public {
        auditLog.addLogger(logger);

        vm.prank(logger);
        vm.expectRevert();
        auditLog.logTrade("AAPL", 150, "HOLD", 1718000000);
    }

    function testRevokedLoggerCannotLogTrade() public {
        auditLog.addLogger(logger);
        auditLog.removeLogger(logger);

        vm.prank(logger);
        vm.expectRevert();
        auditLog.logTrade("AAPL", 150, "BUY", 1718000000);
    }
}