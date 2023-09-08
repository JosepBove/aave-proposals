// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {GovHelpers} from 'aave-helpers/GovHelpers.sol';
import {EthereumScript} from 'aave-helpers/ScriptUtils.sol';
import {AaveV3_Ethereum_MKRDebtCeiling_20230908} from './AaveV3_Ethereum_MKRDebtCeiling_20230908.sol';

/**
 * @dev Deploy AaveV3_Ethereum_MKRDebtCeiling_20230908
 * command: make deploy-ledger contract=src/20230908_AaveV3_Eth_MKRDebtCeiling/AaveV3_MKRDebtCeiling_20230908.s.sol:DeployEthereum chain=mainnet
 */
contract DeployEthereum is EthereumScript {
  function run() external broadcast {
    new AaveV3_Ethereum_MKRDebtCeiling_20230908();
  }
}

/**
 * @dev Create Proposal
 * command: make deploy-ledger contract=src/20230908_AaveV3_Eth_MKRDebtCeiling/AaveV3_MKRDebtCeiling_20230908.s.sol:CreateProposal chain=mainnet
 */
contract CreateProposal is EthereumScript {
  function run() external broadcast {
    GovHelpers.Payload[] memory payloads = new GovHelpers.Payload[](1);
    payloads[0] = GovHelpers.buildMainnet(address(0));
    GovHelpers.createProposal(
      payloads,
      GovHelpers.ipfsHashFile(vm, 'src/20230908_AaveV3_Eth_MKRDebtCeiling/MKRDebtCeiling.md')
    );
  }
}
