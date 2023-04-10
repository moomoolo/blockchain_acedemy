import { ethers, upgrades } from 'hardhat'

async function main() {
  const V1Address = "0x934e74a77eabd6d33ee00f84bb76861c4b6886d7";
  const LogicV2 = await ethers.getContractFactory("LogicV2");
  const logicV2 = await upgrades.upgradeProxy(V1Address, LogicV2);
  await logicV2.deployed();
  console.log('----- logic v2 deployed at: ', logicV2.address);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
