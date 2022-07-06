%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.bool import TRUE
from contracts.types.rewards_data import RewardsDataTypes
from contracts.interfaces.i_scaled_balance_token import IScaledBalanceToken
from starkware.cairo.common.math import assert_lt

@storage_var
func transfer_strategy(reward_address : felt) -> (address : felt):
end

@storage_var
func authorized_claimers(address : felt) -> (address : felt):
end

@storage_var
func reward_oracle(reward_address : felt) -> (address : felt):
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
@event
func transfer_strategy_installed(reward_address, transfer_strategy_address):
end

namespace RewardsController:
    func only_authorized_claimers{
            syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
            claimer : felt, user : felt):
        let (claimer_) = authorized_claimers.read(user)
        with_attr error_message("Claimer not authorized"):
            assert claimer_ = claimer
        end
        return ()
    end

    func configure_assets{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
            config_len, config : RewardsDataTypes.RewardsConfigInput*):
        if config_len == 0:
            return ()
        end

        let (total_supply) = IScaledBalanceToken.get_scaled_total_supply(
            contract_address=config.asset_address)

        assert config.total_supply = total_supply

        with_attr error_message("null strategy"):
            assert_lt(0, config.transfer_strategy)
        end

        transfer_strategy.write(config.reward_address, config.transfer_strategy)

        # Emit event
        transfer_strategy_installed.emit(config.reward_address, config.transfer_strategy)

        set_reward_oracle(config.reward_address, config.reward_oracle_address)

        return configure_assets(
            config_len=config_len - 1, config=config + RewardsDataTypes.RewardsConfigInput.SIZE)
    end

    func claim_rewards{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
            assets_len, assets : felt*, amount : felt, claimer : felt, user : felt, to : felt):
        # TODO

        return ()
    end

    func set_reward_oracle{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
            reward, oracle):
        reward_oracle.write(reward, oracle)
        return ()
    end
    func set_claimer{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
            claimer, user):
        authorized_claimers.write(claimer, user)
        return ()
    end

    func get_reward_oracle{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
            reward_address) -> (oracle_address):
        let (oracle_address) = reward_oracle.read(reward_address)
        return (oracle_address)
    end

    func get_transfer_strategy{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
            reward_address) -> (transfer_strategy_address):
        let (transfer_strategy_address) = transfer_strategy.read(reward_address)
        return (transfer_strategy_address)
    end

    func get_claimer{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
            user : felt) -> (claimer : felt):
        let (claimer) = authorized_claimers.read(user)
        return (claimer)
    end
end
