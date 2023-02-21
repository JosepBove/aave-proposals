// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import {WithChainIdValidation} from './WithChainIdValidation.sol';
import {GovHelpers} from 'aave-helpers/GovHelpers.sol';

contract CreateMainnetProposal is WithChainIdValidation {
  constructor() WithChainIdValidation(1) {}
}

contract FreezeBUSDProposal is CreateMainnetProposal {
  bytes32 internal IPFS_HASH = 0; // TOFIX: Replace with actual hash

  function run() external {
    GovHelpers.Payload[] memory payloads = new GovHelpers.Payload[](1);
    payloads[0] = GovHelpers.buildMainnet(
      0x9c4bf756E2d8dA301121b036958f6B3fcd0FE801
    );
    vm.startBroadcast();
    GovHelpers.createProposal(
      payloads,
      IPFS_HASH // TOFIX: Replace with actual hash
    );
    vm.stopBroadcast();
  }
}
