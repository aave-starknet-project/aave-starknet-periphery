%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin

from contracts.rewards.base.emission_manager_library import EmissionManager

@constructor
func constructor{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    owner : felt, rewards_controller : felt
):
    EmissionManager.initializer(owner, rewards_controller)
    return ()
end

@external
func configure_assets{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}():
    # TODO
    # Needs an oracle.
    EmissionManager.configure_assets()

    return ()
end

@external
func set_transfer_strategy{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    reward : felt
):
    # TODO
    EmissionManager.set_transfer_strategy(reward)

    return ()
end

@external
func set_reward_oracle{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}():
    # TODO
    EmissionManager.set_reward_oracle()

    return ()
end

@external
func set_emission_per_second{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}():
    # TODO
    EmissionManager.set_emission_per_second()

    return ()
end

@external
func set_claimer{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    user : felt, claimer : felt
):
    EmissionManager.set_claimer(user, claimer)
    return ()
end

@external
func set_rewards_controller{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    rewards_controller : felt
):
    EmissionManager.set_rewards_controller(rewards_controller)
    return ()
end

@external
func set_emission_admin{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    reward : felt, admin : felt
):
    EmissionManager.set_emission_admin(reward, admin)
    return ()
end

@view
func get_rewards_controller{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    ) -> (rewards_controller : felt):
    let (res) = EmissionManager.get_rewards_controller()
    return (res)
end

@view
func get_emission_admin{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    reward : felt
) -> (emission_admin_ : felt):
    let (res) = EmissionManager.get_emission_admin(reward)
    return (res)
end
