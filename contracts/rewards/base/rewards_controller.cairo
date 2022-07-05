%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.bool import TRUE
from starkware.starknet.common.syscalls import get_caller_address
from contracts.rewards.base.rewards_distributor import RewardsDistributor

@storage_var
func distribution_manager() -> (address : felt):
end

@storage_var
func reward_token() -> (address : felt):
end

@storage_var
func _authorized_claimers(address : felt) -> (address : felt):
end

# only authorized claimers

func only_authorized_claimers{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        claimer : felt, user : felt):
    let (claimer_) = _authorized_claimers.read(user)
    with_attr error_message("Claimer not authorized"):
        assert claimer_ = claimer
    end
    return ()
end

# only emission manager

func only_emission_manager{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}():
    let (emission_manager_) = RewardsDistributor.get_emission_manager()
    with_attr error_message("Only emission manager"):
        let (caller) = get_caller_address()
        assert caller = emission_manager_
    end
    return ()
end

# events
@event
func rewards_claimed(user : felt, to : felt, claimer : felt, amount : felt):
end

@event
func rewards_accrued(user : felt, amount : felt):
end

@event
func claimer_set(claimer : felt):
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
    # _claim_rewards()
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

@external
func set_claimer{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        user : felt, caller : felt):
    only_emission_manager()
    _authorized_claimers.write(user, caller)

    return ()
end

@view
func get_claimer{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        user : felt) -> (claimer : felt):
    let (claimer) = _authorized_claimers.read(user)
    return (claimer)
end

@view
func get_emission_manager{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}() -> (
        emission_manager_ : felt):
    let (emission_manager) = RewardsDistributor.get_emission_manager()
    return (emission_manager)
end

@view
func get_reward_token{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}() -> (
        reward_token_ : felt):
    let (reward_token_) = reward_token.read()
    return (reward_token_)
end

# internals
func _claim_rewards{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        assets : felt*, amount : felt, claimer : felt, user : felt, to : felt):
    # TODO

    return ()
end
