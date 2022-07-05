%lang starknet

from starkware.cairo.common.uint256 import Uint256

namespace RewardsDataTypes:
    struct RewardsConfigInput:
        member emission_per_second : Uint256
        member total_supply : Uint256
        member distribution_end : felt
        member asset_address : felt
        member reward_address : felt
        member transfer_strategy : felt
        member reward_oracle : felt
    end
end
