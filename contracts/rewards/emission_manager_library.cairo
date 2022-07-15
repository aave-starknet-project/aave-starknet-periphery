%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.starknet.common.syscalls import get_caller_address

from openzeppelin.access.ownable import Ownable
from onlydust.stream.default_implementation import stream

from contracts.interfaces.i_rewards_controller import IRewardsController

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
        config : felt
    ):
        # TODO
        # Should check the sender is emission admin of each reward
        # contained in the config
        # And call reward controllers function.
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
        asset : felt, rewards : felt, new_emissions_per_second : felt
    ):
        # TODO
        # Should check the sender is emission admin of each reward
        # contained in the config
        # Should use same helper from configure_assets
        # And call reward controllers function.
        return ()
    end

    func set_claimer{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        _user : felt, _claimer : felt
    ):
        Ownable.assert_only_owner()
        let (reward_controller_address) = EmissionManager_rewards_controller.read()
        IRewardsController.set_claimer(
            contract_address=reward_controller_address, user=_user, claimer=_claimer
        )
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

    func _validate_emission_admins{
        syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
    }(rewards_len : felt, rewards : felt*):
        stream.foreach(_validate_emission_admin_wrapper, rewards_len, rewards)
        return ()
    end

    func _validate_emission_admin_wrapper{
        syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
    }(index : felt, el : felt*):
        let (emission_admin) = EmissionManager_emission_admins.read(el)
        # Value to pointer
        with_attr error_message("Sender is not emission admin of pool: {el}"):
            assert_only_emission_admin(emission_admin)
        end
        return ()
    end
end
