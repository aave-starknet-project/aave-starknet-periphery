%lang starknet

from starkware.cairo.common.uint256 import Uint256

namespace RewardsDataTypes {
    struct RewardsConfigInput {
        emission_per_second: Uint256,
        total_supply: Uint256,
        distribution_end: felt,
        asset_address: felt,
        reward_address: felt,
        transfer_strategy: felt,
        reward_oracle: felt,
    }
}
