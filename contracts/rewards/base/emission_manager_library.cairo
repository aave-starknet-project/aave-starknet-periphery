%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.starknet.common.syscalls import get_caller_address

from openzeppelin.access.ownable import Ownable

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
func _emission_admins(reward : felt) -> (admin : felt):
end

@storage_var
func _rewards_controller() -> (address : felt):
end

namespace EmissionManager:
    # Authorization

    func assert_only_emission_admin{
        syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
    }(reward : felt):
        let (emission_admin) = _emission_admins.read(reward)
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
        _rewards_controller.write(rewards_controller)

        return ()
    end

    func configure_assets{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}():
        # TODO
        # Needs an oracle.
        return ()
    end

    func set_transfer_strategy{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        reward : felt
    ):
        assert_only_emission_admin(reward)
        # TODO
        return ()
    end

    func set_reward_oracle{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}():
        # TODO
        return ()
    end

    func set_emission_per_second{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        ):
        # TODO
        return ()
    end

    func set_claimer{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        _user : felt, _claimer : felt
    ):
        Ownable.assert_only_owner()
        let (reward_controller_address) = _rewards_controller.read()
        IRewardsController.set_claimer(
            contract_address=reward_controller_address, user=_user, claimer=_claimer
        )
        return ()
    end

    func set_rewards_controller{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        rewards_controller_ : felt
    ):
        Ownable.assert_only_owner()

        _rewards_controller.write(rewards_controller_)

        return ()
    end

    func set_emission_admin{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        reward : felt, admin : felt
    ):
        Ownable.assert_only_owner()

        let (old_admin) = _emission_admins.read(reward)
        _emission_admins.write(reward, admin)

        emission_admin_updated.emit(old_admin=old_admin, new_admin=admin)

        return ()
    end

    # Getters

    func get_rewards_controller{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        ) -> (res : felt):
        let (res) = _rewards_controller.read()
        return (res)
    end

    func get_emission_admin{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        reward : felt
    ) -> (res : felt):
        let (res) = _emission_admins.read(reward)
        return (res)
    end

    # Internals
end
