let WibFactory = artifacts.require('WibFactory')

module.exports = async function(deployer) {
  await deployer.deploy(WibFactory).then(async () => {})
}
