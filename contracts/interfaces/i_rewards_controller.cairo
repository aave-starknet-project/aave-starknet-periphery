%lang starknet

@contract_interface
namespace IRewardsController {
    func set_claimer(user: felt, claimer: felt) {
    }
    func get_claimer(user: felt) -> (res: felt) {
    }
    func handle_action(asset: felt, user_balance: felt, total_supply: felt) {
    }
    func get_reward_token() -> (res: felt) {
    }
    func claim_rewards() {
    }
    func get_distribution_end() -> (res: felt) {
    }
    func get_emission_manager() -> (res: felt) {
    }
}
