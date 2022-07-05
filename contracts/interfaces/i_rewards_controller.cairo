%lang starknet

@contract_interface
namespace IRewardsController:
    func set_claimer(user : felt, claimer : felt):
    end
    func get_claimer(user : felt) -> (res : felt):
    end
    func handle_action(asset : felt, user_balance : felt, total_supply : felt):
    end
    func get_reward_token() -> (res : felt):
    end
    func claim_rewards():
    end
    func get_distribution_end() -> (res : felt):
    end
    func get_emission_manager() -> (res : felt):
    end
end
