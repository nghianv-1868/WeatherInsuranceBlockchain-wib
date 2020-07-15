let WibFactory = artifacts.require('WibFactory')

module.exports = async function(deployer) {
  // deployer.deploy(Integers).then(function() {
  //   return deployer.deploy(WibFactory, Integers.address)
  // })
  // await deployer.deploy(Integers)
  // await deployer.link(Integers, WibFactory)
  await deployer.deploy(WibFactory).then(async () => {
    // var factory = await WibFactory.deployed()
    // await factory.createEvi()
  })
}
