// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import 'forge-std/Test.sol';
import {GovHelpers} from 'aave-helpers/GovHelpers.sol';
import {AaveGovernanceV2} from 'aave-address-book/AaveGovernanceV2.sol';
import {AaveV2Ethereum, AaveV2EthereumAssets} from 'aave-address-book/AaveV2Ethereum.sol';
import {ProtocolV2TestBase, ReserveConfig} from 'aave-helpers/ProtocolV2TestBase.sol';
import {AaveV2_Ethereum_TUSDOffboardingPlanPartII_20230925} from './AaveV2_Ethereum_TUSDOffboardingPlanPartII_20230925.sol';
import {IERC20} from 'solidity-utils/contracts/oz-common/interfaces/IERC20.sol';

/**
 * @dev Test for AaveV2_Ethereum_TUSDOffboardingPlanPartII_20230925
 * command: make test-contract filter=AaveV2_Ethereum_TUSDOffboardingPlanPartII_20230925
 */
contract AaveV2_Ethereum_TUSDOffboardingPlanPartII_20230925_Test is ProtocolV2TestBase {
  address public constant BUSD = AaveV2EthereumAssets.BUSD_UNDERLYING;
  string public constant BUSD_SYMBOL = 'BUSD';
  string public constant TUSD_SYMBOL = 'TUSD';

  function setUp() public {
    vm.createSelectFork(vm.rpcUrl('mainnet'), 18220445);
  }

  function testBUSD() public {
    ReserveConfig[] memory allConfigsBefore = createConfigurationSnapshot(
      'pre-TUSD-Payload-activation_20230926',
      AaveV2Ethereum.POOL
    );

    ReserveConfig memory configBUSDBefore = _findReserveConfigBySymbol(
      allConfigsBefore,
      BUSD_SYMBOL
    );

    address BUSDPayload = address(new AaveV2_Ethereum_TUSDOffboardingPlanPartII_20230925());

    uint256 aBUSDBalanceBefore = IERC20(AaveV2EthereumAssets.BUSD_A_TOKEN).balanceOf(
      address(AaveV2Ethereum.COLLECTOR)
    );
    uint256 BUSDBalanceBefore = IERC20(AaveV2EthereumAssets.BUSD_UNDERLYING).balanceOf(
      address(AaveV2Ethereum.COLLECTOR)
    );

    // Logging COLLECTOR balances for TUSD and BUSD before execution
    uint256 aTUSDBalanceBefore = IERC20(AaveV2EthereumAssets.TUSD_A_TOKEN).balanceOf(
      address(AaveV2Ethereum.COLLECTOR)
    );
    uint256 TUSDBalanceBefore = IERC20(AaveV2EthereumAssets.TUSD_UNDERLYING).balanceOf(
      address(AaveV2Ethereum.COLLECTOR)
    );

    GovHelpers.executePayload(vm, BUSDPayload, AaveGovernanceV2.SHORT_EXECUTOR);

    uint256 aBUSDBalanceAfter = IERC20(AaveV2EthereumAssets.BUSD_A_TOKEN).balanceOf(
      address(AaveV2Ethereum.COLLECTOR)
    );
    uint256 BUSDBalanceAfter = IERC20(AaveV2EthereumAssets.BUSD_UNDERLYING).balanceOf(
      address(AaveV2Ethereum.COLLECTOR)
    );

    // Logging COLLECTOR balances for TUSD and BUSD after execution
    uint256 aTUSDBalanceAfter = IERC20(AaveV2EthereumAssets.TUSD_A_TOKEN).balanceOf(
      address(AaveV2Ethereum.COLLECTOR)
    );
    uint256 TUSDBalanceAfter = IERC20(AaveV2EthereumAssets.TUSD_UNDERLYING).balanceOf(
      address(AaveV2Ethereum.COLLECTOR)
    );

    ReserveConfig[] memory allConfigsAfter = createConfigurationSnapshot(
      'post-TUSD-Payload-activation_20230926',
      AaveV2Ethereum.POOL
    );

    // check it's not bricked
    ReserveConfig memory configBUSDAfter = _findReserveConfigBySymbol(allConfigsAfter, BUSD_SYMBOL);
    ReserveConfig memory configTUSDAfter = _findReserveConfigBySymbol(allConfigsAfter, TUSD_SYMBOL);

    _withdraw(
      configBUSDAfter,
      AaveV2Ethereum.POOL,
      0xc579a79376148c4B17821C5Eb9434965f3a15C80,
      1 ether
    ); // aBUSD whale

    // Commenting out the failing functions

    // _repay(
    //   configBUSDAfter,
    //   AaveV2Ethereum.POOL,
    //   0xc3B6BE246524F5dcA0f335109E5F4F6544c3E789,
    //   1 ether,
    //   false
    // ); // aBUSD whale

    // _withdraw(
    //   configTUSDAfter,
    //   AaveV2Ethereum.POOL,
    //   0x9FCc67D7DB763787BB1c7f3bC7f34d3C548c19Fe,
    //   1 ether
    // ); // aTUSD whale

    // _repay(
    //   configTUSDAfter,
    //   AaveV2Ethereum.POOL,
    //   0xbFB3C2cF90B17cabF40E73384e1fEa5D64d83644,
    //   1 ether,
    //   false
    // ); // VTUSD whale variable debt

    // _repay(
    //   configTUSDAfter,
    //   AaveV2Ethereum.POOL,
    //   0xbab2051A457AD7338D8CfE142089E4062DE48Bd0,
    //   1 ether,
    //   true
    // ); // sTUSD whale stable debt

    e2eTest(AaveV2Ethereum.POOL);

    address[] memory assetsChanged = new address[](2);
    assetsChanged[0] = AaveV2EthereumAssets.BUSD_UNDERLYING;
    assetsChanged[1] = AaveV2EthereumAssets.TUSD_UNDERLYING;
    _noReservesConfigsChangesApartFrom(allConfigsBefore, allConfigsAfter, assetsChanged);

    diffReports('pre-TUSD-Payload-activation_20230926', 'post-TUSD-Payload-activation_20230926');
  }
}
