const CardContract = artifacts.require("CardContract");

module.exports = function (deployer) {
  deployer.deploy(CardContract);
};
