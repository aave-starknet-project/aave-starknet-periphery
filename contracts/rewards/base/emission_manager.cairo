%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.starknet.common.syscalls import get_caller_address

from openzeppelin.access.ownable import Ownable

@storage_var
func _emission_admins(reward : felt) -> (admin : felt):
end

@storage_var
func _rewards_controller() -> (address : felt):
end

@event
func emission_admin_updated(old_admin : felt, new_admin : felt):
end

func only_emission_admin{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    reward: felt
):
    let (emission_admin_) = _emission_admins.read(reward)
    with_attr error_message("Only emission admin"):
        let (caller) = get_caller_address()
        assert caller = emission_admin_
    end
    return ()
end

@constructor
func constructor{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    owner : felt,
    rewards_controller : felt
):
    Ownable.initializer(owner)
    _rewards_controller.write(rewards_controller)
    return ()
end

@external
func configure_assets{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}():
    # TODO
    return()
end

@external
func set_transfer_strategy{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}():
    # TODO
    return()
end

@external
func set_reward_oracle{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}():
    # TODO
    return()
end

@external
func set_emission_per_second{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}():
    # TODO
    return()
end

@external
func set_claimer{}():
    # TODO
    return()
end

@external
func set_rewards_controller{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    rewards_controller_ : felt
):
    Ownable.assert_only_owner()
    # Event for update?
    # Check rewards_controller is address? Check is not addr zero?
    _rewards_controller.write(rewards_controller_)
    return()
end

@external
func set_emission_admin{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    reward : felt, admin: felt
):
    Ownable.assert_only_owner()
    let (old_admin) = _emission_admins.read(reward)
    # Check that is valid address? Check that it is not address zero?
    _emission_admins.write(reward, admin)
    return()
end

@view
func get_rewards_controller{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
) -> (
    rewards_controller_ : felt
):
    let (rewards_controller_) = _rewards_controller.read()
    return(rewards_controller_)
end

@view
func get_emission_admin{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    reward: felt
) -> (
    emission_admin_ : felt
):
    let (emission_admin_) = _emission_admins.read(reward)
    return (emission_admin_)
end