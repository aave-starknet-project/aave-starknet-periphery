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

@view
func get_rewards_controller{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    ) -> (rewards_controller : felt):
    let (rewards_controller) = EmissionManager.get_rewards_controller()
    return (rewards_controller)
end

@view
func get_emission_admin{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    reward : felt
) -> (emission_admin : felt):
    let (emission_admin) = EmissionManager.get_emission_admin(reward)
    return (emission_admin)
end

# config is RewardsDataTypes.RewardsConfigInput[], needs to receive length, also, recursion
@external
func configure_assets{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    config : felt
):
    EmissionManager.configure_assets()
    return ()
end

# transfer_strategy is ITransferStrategyBase
@external
func set_transfer_strategy{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    reward : felt, transfer_strategy : felt
):
    EmissionManager.set_transfer_strategy(reward)
    return ()
end

@external
func set_reward_oracle{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    reward : felt, reward_oracle : felt
):
    EmissionManager.set_reward_oracle(reward, reward_oracle)
    return ()
end

# new_distribution_end is uint32
@external
func set_distribution_end{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    asset : felt, reward : felt, new_distribution_end : felt
):
    EmissionManager.set_distribution_end(asset, reward, new_distribution_end)
    return ()
end

# rewards is an array of addresses, needs to receive length
# new_emissions_per_second an array of uint88, why? needs to receive length
@external
func set_emission_per_second{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    asset : felt, rewards : felt, new_emissions_per_second : felt
):
    EmissionManager.set_emission_per_second(asset, rewards, new_emissions_per_second)
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
