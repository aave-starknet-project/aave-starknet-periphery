%lang starknet

from contracts.types.rewards_data import RewardsDataTypes

@contract_interface
namespace IEmissionManager {
    func configure_assets(config_len: felt, config: RewardsDataTypes.RewardsConfigInput*) {
    }

    func set_transfer_strategy(reward: felt, transfer_strategy: felt) {
    }

    func set_reward_oracle(reward: felt, reward_oracle: felt) {
    }

    func set_distribution_end(asset: felt, reward: felt, new_distribution_end: felt) {
    }

    func set_emission_per_second(
        asset: felt,
        rewards_len: felt,
        rewards: felt*,
        new_emissions_per_second_len: felt,
        new_emissions_per_second: felt*,
    ) {
    }

    func set_claimer(user: felt, claimer: felt) {
    }

    func set_emission_manager(emission_manager: felt) {
    }

    func set_rewards_controller(rewards_controller: felt) {
    }

    func set_emission_admin(reward: felt, admin: felt) {
    }

    func get_rewards_controller() -> (rewards_controller: felt) {
    }

    func get_emission_admin(reward: felt) -> (emission_admin: felt) {
    }
}
