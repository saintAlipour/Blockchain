const { expect } = require("chai");
const hre = require("hardhat");

describe("AuditLog Contract", function () {
  let auditLog;
  let owner;
  let logger;
  let addr1;

  beforeEach(async function () {
    // گرفتن اکانت‌های تست
    [owner, logger, addr1] = await hre.ethers.getSigners();

    // دیپلوی مجدد قرارداد برای هر تست
    const AuditLog = await hre.ethers.getContractFactory("AuditLog");
    auditLog = await AuditLog.deploy(owner.address);
    await auditLog.waitForDeployment();
  });

  it("Should set the right owner", async function () {
    expect(await auditLog.owner()).to.equal(owner.address);
  });

  it("Should allow owner to add a logger", async function () {
    await auditLog.addLogger(logger.address);
    expect(await auditLog.authLoggers(logger.address)).to.equal(true);
  });

  it("Should allow authorized logger to log a trade", async function () {
    await auditLog.addLogger(logger.address);
    
    // اتصال به قرارداد با اکانت لاگر
    const auditLogAsLogger = auditLog.connect(logger);
    
    // ثبت ترید
    await expect(auditLogAsLogger.logTrade("BTCUSDT", 90000, "BUY", 123456789))
      .to.emit(auditLog, "TradeLogged")
      .withArgs(logger.address, "BTCUSDT", 90000, "BUY", 123456789, 1);
      
    expect(await auditLog.logCount()).to.equal(1);
  });
});