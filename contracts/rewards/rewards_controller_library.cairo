%lang starknet

from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.bool import TRUE
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.math import assert_lt

from contracts.interfaces.i_scaled_balance_token import IScaledBalanceToken
from contracts.types.rewards_data import RewardsDataTypes

@storage_var
func transfer_strategy(reward_address: felt) -> (address: felt) {
}

@storage_var
func authorized_claimers(address: felt) -> (address: felt) {
}

@storage_var
func reward_oracle(reward_address: felt) -> (address: felt) {
}

// events
@event
func rewards_claimed(user: felt, to: felt, claimer: felt, amount: felt) {
}

@event
func rewards_accrued(user: felt, amount: felt) {
}

@event
func claimer_set(claimer: felt) {
}

@event
func transfer_strategy_installed(reward_address, transfer_strategy_address) {
}

namespace RewardsController {
    func only_authorized_claimers{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        claimer: felt, user: felt
    ) {
        let (claimer_) = authorized_claimers.read(user);
        with_attr error_message("Claimer not authorized") {
            assert claimer_ = claimer;
        }
        return ();
    }

    func configure_assets{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        config_len, config: RewardsDataTypes.RewardsConfigInput*
    ) {
        if (config_len == 0) {
            return ();
        }

        let (total_supply) = IScaledBalanceToken.get_scaled_total_supply(
            contract_address=config.asset_address
        );

        assert config.total_supply = total_supply;

        with_attr error_message("null strategy") {
            assert_lt(0, config.transfer_strategy);
        }

        transfer_strategy.write(config.reward_address, config.transfer_strategy);

        // Emit event
        transfer_strategy_installed.emit(config.reward_address, config.transfer_strategy);

        set_reward_oracle(config.reward_address, config.reward_oracle_address);

        return configure_assets(
            config_len=config_len - 1, config=config + RewardsDataTypes.RewardsConfigInput.SIZE
        );
    }

    func claim_rewards{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        assets_len, assets: felt*, amount: felt, claimer: felt, user: felt, to: felt
    ) {
        // TODO

        return ();
    }

    func set_reward_oracle{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        reward, oracle
    ) {
        reward_oracle.write(reward, oracle);
        return ();
    }

    func set_claimer{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        claimer, user
    ) {
        authorized_claimers.write(claimer, user);
        return ();
    }

    func get_reward_oracle{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        reward_address
    ) -> (oracle_address: felt) {
        let (oracle_address) = reward_oracle.read(reward_address);
        return (oracle_address,);
    }

    func get_transfer_strategy{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        reward_address
    ) -> (transfer_strategy_address: felt) {
        let (transfer_strategy_address) = transfer_strategy.read(reward_address);
        return (transfer_strategy_address,);
    }

    func get_claimer{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        user: felt
    ) -> (claimer: felt) {
        let (claimer) = authorized_claimers.read(user);
        return (claimer,);
    }
}
