%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.bool import TRUE
from starkware.starknet.common.syscalls import get_caller_address
from contracts.rewards.base.rewards_distributor import RewardsDistributor
from contracts.rewards.base.rewards_controller_library import RewardsController
from contracts.types.rewards_data import RewardsDataTypes
func only_emission_manager{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}():
    let (emission_manager_) = RewardsDistributor.get_emission_manager()
    with_attr error_message("Only emission manager"):
        let (caller) = get_caller_address()
        assert caller = emission_manager_
    end
    return ()
end

@constructor
func constructor{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        emission_manager_ : felt):
    RewardsDistributor.set_emission_manager(emission_manager_)
    return ()
end
@external
func hande_action{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        reward_token_ : felt, distribution_manager_ : felt):
    return ()
end

@external
func claim_rewards{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        assets_len, assets : felt*, to : felt):
    # TODO
    # _claim_rewards()
    return ()
end

@external
func claim_rewards_on_behalf{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        assets_len, assets : felt*, amount : felt, user : felt, to : felt):
    # RewardsController.claim_rewards()
    return ()
end

@external
func claim_rewards_to_self{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        assets_len, assets : felt*, user : felt):
    # _claim_rewards()
    return ()
end

@view
func get_rewards_balance{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        assets_len, assets : felt*, user : felt):
    # TODO
    return ()
end

@view
func get_reward_oracle{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        reward_address) -> (oracle_address):
    let (oracle_address) = RewardsController.get_reward_oracle(reward_address)
    return (oracle_address)
end
@view
func get_transfer_strategy{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        reward_address) -> (transfer_strategy_address):
    let (transfer_strategy_address) = RewardsController.get_transfer_strategy(reward_address)
    return (transfer_strategy_address)
end

@external
func set_claimer{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        user : felt, caller : felt):
    only_emission_manager()
    RewardsController.set_claimer(user, caller)

    return ()
end

@external
func set_rewards_oracle{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        reward : felt, oracle : felt):
    only_emission_manager()
    RewardsController.set_reward_oracle(reward, oracle)

    return ()
end

@external
func configure_assets{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        config_len, config : RewardsDataTypes.RewardsConfigInput*):
    only_emission_manager()
    # TODO: implement internal configAssets on rewards_distributor==>takes config as arg

    RewardsDistributor.configure_assets(config_len, config)

    return ()
end

@view
func get_claimer{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        user : felt) -> (claimer : felt):
    let (claimer) = RewardsController.get_claimer(user)
    return (claimer)
end

@view
func get_emission_manager{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}() -> (
        emission_manager_ : felt):
    let (emission_manager) = RewardsDistributor.get_emission_manager()
    return (emission_manager)
end
