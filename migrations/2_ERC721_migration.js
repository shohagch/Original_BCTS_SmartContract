const ERC721 = artifacts.require("ERC721");

module.exports = function (deployer, network, accounts) {
  deployer.deploy(ERC721, "SELISE xBDT", "xBDT");
};
