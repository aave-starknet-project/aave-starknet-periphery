%lang starknet

from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.memcpy import memcpy
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.starknet.common.syscalls import get_caller_address

from openzeppelin.access.ownable.library import Ownable

from contracts.interfaces.i_rewards_controller import IRewardsController
from contracts.types.rewards_data import RewardsDataTypes

//
// Events
//

@event
func emission_admin_updated(old_admin: felt, new_admin: felt) {
}

//
// Storage
//

@storage_var
func EmissionManager_emission_admins(reward: felt) -> (admin: felt) {
}

@storage_var
func EmissionManager_rewards_controller() -> (address: felt) {
}

namespace EmissionManager {
    // Authorization

    func assert_only_emission_admin{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr
    }(reward: felt) {
        let (emission_admin) = EmissionManager_emission_admins.read(reward);
        with_attr error_message("Only emission admin can modify pool: {reward}") {
            let (caller) = get_caller_address();
            assert caller = emission_admin;
        }
        return ();
    }

    // Externals

    func initializer{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        owner: felt, rewards_controller: felt
    ) {
        Ownable.initializer(owner);
        EmissionManager_rewards_controller.write(rewards_controller);

        return ();
    }

    func configure_assets{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        config_len: felt, config: RewardsDataTypes.RewardsConfigInput*
    ) {
        _validate_config_assets(config_len, config);
        // TODO
        // Call reward controllers function.
        return ();
    }

    func set_transfer_strategy{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        reward: felt, transfer_strategy: felt
    ) {
        assert_only_emission_admin(reward);
        // TODO
        // Call reward controllers function.
        return ();
    }

    func set_reward_oracle{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        reward: felt, reward_oracle: felt
    ) {
        assert_only_emission_admin(reward);
        // TODO
        // Call reward controllers function.
        return ();
    }

    func set_distribution_end{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        asset: felt, reward: felt, new_distribution_end: felt
    ) {
        assert_only_emission_admin(reward);
        // TODO
        // Call reward controllers function.
        return ();
    }

    func set_emission_per_second{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        asset: felt,
        rewards_len: felt,
        rewards: felt*,
        new_emissions_per_second_len: felt,
        new_emissions_per_second: felt*,
    ) {
        // TODO
        // Call reward controllers function.
        _validate_rewards(rewards_len, rewards);
        return ();
    }

    func set_emission_manager{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        emission_manager
    ) {
        Ownable.assert_only_owner();
        // TODO
        // Properly implement set_emission_manager in reward
        return ();
    }

    func set_claimer{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        user: felt, claimer: felt
    ) {
        Ownable.assert_only_owner();

        let (reward_controller_address) = EmissionManager_rewards_controller.read();

        // TODO
        // Properly implement set_claimer in reward
        // IRewardsController.set_claimer(
        //     contract_address=reward_controller_address, user=user, claimer=claimer
        // )
        return ();
    }

    func set_rewards_controller{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        rewards_controller: felt
    ) {
        Ownable.assert_only_owner();

        EmissionManager_rewards_controller.write(rewards_controller);

        return ();
    }

    func set_emission_admin{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        reward: felt, admin: felt
    ) {
        Ownable.assert_only_owner();

        let (old_admin) = EmissionManager_emission_admins.read(reward);
        EmissionManager_emission_admins.write(reward, admin);

        emission_admin_updated.emit(old_admin=old_admin, new_admin=admin);

        return ();
    }

    // Getters

    func get_rewards_controller{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        ) -> (res: felt) {
        let (res) = EmissionManager_rewards_controller.read();
        return (res,);
    }

    func get_emission_admin{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        reward: felt
    ) -> (res: felt) {
        let (res) = EmissionManager_emission_admins.read(reward);
        return (res,);
    }

    // Internals

    func _validate_config_assets{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        config_len: felt, config: RewardsDataTypes.RewardsConfigInput*
    ) {
        alloc_locals;

        if (config_len == 0) {
            return ();
        }

        let input = config[0];
        assert_only_emission_admin(input.reward_address);

        return _validate_config_assets(
            config_len - 1, config + RewardsDataTypes.RewardsConfigInput.SIZE
        );
    }

    func _validate_rewards{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        rewards_len: felt, rewards: felt*
    ) {
        alloc_locals;

        if (rewards_len == 0) {
            return ();
        }

        let reward = [rewards];
        assert_only_emission_admin(reward);

        return _validate_rewards(rewards_len - 1, rewards + 1);
    }
}
