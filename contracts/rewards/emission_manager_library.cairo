%lang starknet

from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.memcpy import memcpy
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.starknet.common.syscalls import get_caller_address

from openzeppelin.access.ownable import Ownable
from onlydust.stream.default_implementation import stream
from onlydust.stream.generic import generic

from contracts.interfaces.i_rewards_controller import IRewardsController
from contracts.types.rewards_data import RewardsDataTypes

#
# Events
#

@event
func emission_admin_updated(old_admin : felt, new_admin : felt):
end

#
# Storage
#

@storage_var
func EmissionManager_emission_admins(reward : felt) -> (admin : felt):
end

@storage_var
func EmissionManager_rewards_controller() -> (address : felt):
end

namespace EmissionManager:
    # Authorization

    func assert_only_emission_admin{
        syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
    }(reward : felt):
        let (emission_admin) = EmissionManager_emission_admins.read(reward)
        with_attr error_message("Only emission admin"):
            let (caller) = get_caller_address()
            assert caller = emission_admin
        end
        return ()
    end

    # Externals

    func initializer{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        owner : felt, rewards_controller : felt
    ):
        Ownable.initializer(owner)
        EmissionManager_rewards_controller.write(rewards_controller)

        return ()
    end

    func configure_assets{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        config_len : felt, config : RewardsDataTypes.RewardsConfigInput*
    ):
        # TODO
        # Call reward controllers function.
        alloc_locals

        let (temp_rewards : felt*) = alloc()

        let (local __, local ___, local rewards_len, local rewards) = _get_rewards_from_config(
            config_len, config, 0, temp_rewards
        )

        _validate_emission_admins(rewards_len, rewards)
        return ()
    end

    func set_transfer_strategy{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        reward : felt, transfer_strategy : felt
    ):
        assert_only_emission_admin(reward)
        # TODO
        # Call reward controllers function.
        return ()
    end

    func set_reward_oracle{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        reward : felt, reward_oracle : felt
    ):
        assert_only_emission_admin(reward)
        # TODO
        # Call reward controllers function.
        return ()
    end

    func set_distribution_end{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        asset : felt, reward : felt, new_distribution_end : felt
    ):
        assert_only_emission_admin(reward)
        # TODO
        # Call reward controllers function.
        return ()
    end

    func set_emission_per_second{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        asset : felt,
        rewards_len : felt,
        rewards : felt*,
        new_emissions_per_second_len : felt,
        new_emissions_per_second : felt*,
    ):
        # TODO
        # Call reward controllers function.
        _validate_emission_admins(rewards_len, rewards)
        return ()
    end

    func set_emission_manager{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        emission_manager
    ):
        Ownable.assert_only_owner()
        # TODO
        # Properly implement set_emission_manager in reward
        return ()
    end

    func set_claimer{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        user : felt, claimer : felt
    ):
        Ownable.assert_only_owner()

        let (reward_controller_address) = EmissionManager_rewards_controller.read()

        # TODO
        # Properly implement set_claimer in reward
        # IRewardsController.set_claimer(
        #     contract_address=reward_controller_address, user=user, claimer=claimer
        # )
        return ()
    end

    func set_rewards_controller{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        rewards_controller : felt
    ):
        Ownable.assert_only_owner()

        EmissionManager_rewards_controller.write(rewards_controller)

        return ()
    end

    func set_emission_admin{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        reward : felt, admin : felt
    ):
        Ownable.assert_only_owner()

        let (old_admin) = EmissionManager_emission_admins.read(reward)
        EmissionManager_emission_admins.write(reward, admin)

        emission_admin_updated.emit(old_admin=old_admin, new_admin=admin)

        return ()
    end

    # Getters

    func get_rewards_controller{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        ) -> (res : felt):
        let (res) = EmissionManager_rewards_controller.read()
        return (res)
    end

    func get_emission_admin{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        reward : felt
    ) -> (res : felt):
        let (res) = EmissionManager_emission_admins.read(reward)
        return (res)
    end

    # Internals

    func _get_rewards_from_config{
        syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
    }(
        config_len : felt,
        config : RewardsDataTypes.RewardsConfigInput*,
        rewards_len : felt,
        rewards : felt*,
    ) -> (
        config_len : felt,
        config : RewardsDataTypes.RewardsConfigInput*,
        rewards_len : felt,
        rewards : felt*,
    ):
        if config_len == 0:
            return (0, &config[0], rewards_len, rewards)
        end

        let config_value = config[0]

        memcpy(&rewards[rewards_len], &config_value.reward_address, 1)

        return _get_rewards_from_config(
            config_len - 1, &config[rewards_len + 1], rewards_len + 1, rewards
        )
    end

    func _validate_emission_admins{
        syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
    }(rewards_len : felt, rewards : felt*):
        stream.foreach(_validate_emission_admin_wrapper, rewards_len, rewards)
        return ()
    end

    func _validate_emission_admin_wrapper{
        syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
    }(index : felt, el : felt*):
        let reward = [el]
        with_attr error_message("Sender is not emission admin of pool: {reward}."):
            assert_only_emission_admin(reward)
        end
        return ()
    end
end
