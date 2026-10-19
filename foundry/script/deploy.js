const hre = require("hardhat");

async function main() {
  console.log("Deploying AuditLog contract...");

  // گرفتن آدرس دیپلوی‌کننده
  const [deployer] = await hre.ethers.getSigners();
  console.log("Deploying with account:", deployer.address);

  // ساخت نمونه از قرارداد
  const AuditLog = await hre.ethers.getContractFactory("AuditLog");
  
  // دیپلوی قرارداد و پاس دادن آدرس دیپلوی‌کننده به عنوان initialOwner
  const auditLog = await AuditLog.deploy(deployer.address);

  // صبر کردن تا دیپلوی کامل شود
  await auditLog.waitForDeployment();

  // گرفتن آدرس قرارداد
  const address = await auditLog.getAddress();
  console.log("AuditLog deployed to:", address);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});