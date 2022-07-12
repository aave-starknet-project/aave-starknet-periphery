%lang starknet

@contract_interface
namespace IEmissionManager:
    func configure_assets():
    end
    func set_transfer_strategy():
    end
    func set_reward_oracle():
    end
    func set_emission_per_second():
    end
    func set_claimer():
    end
    func set_rewards_controller(rewards_controller_ : felt):
    end
    func set_emission_admin(reward : felt, admin: felt):
    end
    func get_rewards_controller() -> (rewards_controller_ : felt):
    end
    func get_emission_admin() -> (emission_admin_ : felt)
end