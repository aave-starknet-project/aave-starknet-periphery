%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.bool import TRUE
from contracts.types.rewards_data import RewardsDataTypes

# immutable, should only be set once
@storage_var
func emission_manager() -> (address : felt):
end

namespace RewardsDistributor:
    func set_emission_manager{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
            emission_manager_ : felt):
        let (current_emission_manager) = emission_manager.read()
        with_attr error_message("Already initialized"):
            assert current_emission_manager = 0
        end
        emission_manager.write(emission_manager_)
        return ()
    end

    func get_emission_manager{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
            ) -> (address : felt):
        let (emission_manager_) = emission_manager.read()
        return (emission_manager_)
    end

    # @dev Configure the assets for a specific emission
    # @param assetsConfigInput The array of each asset configuration

    func configure_assets{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
            config_input_len, config_input : RewardsDataTypes.RewardsConfigInput*):
        return ()
    end
end
