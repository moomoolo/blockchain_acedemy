import { ethers, upgrades } from 'hardhat'

async function main() {
  const LogicV1 = await ethers.getContractFactory("LogicV1");
  const logicV1 = await upgrades.deployProxy(LogicV1);
  await logicV1.deployed();
  console.log('----- logic v1 deployed at: ', logicV1.address);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
