%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin

from contracts.interfaces.i_emission_manager import IEmissionManager

const OWNER = 111
const REWARDS_CONTROLLER = 222
const EMISSION_ADMIN = 333
const EMISSION_MANAGER = 444
const REWARD_1 = 555
const REWARD_2 = 666

@view
func __setup__{syscall_ptr : felt*, range_check_ptr}():
    %{
        context.emission_manager = deploy_contract("./contracts/rewards/base/emission_manager.cairo", [ids.OWNER, ids.REWARDS_CONTROLLER]).contract_address
        context.rewards_controller_1 = deploy_contract("./contracts/rewards/base/rewards_controller.cairo", [ids.EMISSION_MANAGER]).contract_address
        context.rewards_controller_2 = deploy_contract("./contracts/rewards/base/rewards_controller.cairo", [ids.EMISSION_MANAGER]).contract_address
    %}
    return ()
end

func get_contract_addresses() -> (
    emission_manager : felt,
    rewards_controller_1 : felt,
    rewards_controller_2 : felt
):
    tempvar emission_manager
    tempvar rewards_controller_1
    tempvar rewards_controller_2
    %{ 
        ids.emission_manager = context.emission_manager
        ids.rewards_controller_1 = context.rewards_controller_1
        ids.rewards_controller_2 = context.rewards_controller_2
    %}
    return (emission_manager, rewards_controller_1, rewards_controller_2)
end

@external
func test_constructor{syscall_ptr : felt*, range_check_ptr}():
    alloc_locals
    let (local emission_manager, local __, local ___) = get_contract_addresses()

    let (reward_controller) = IEmissionManager.get_rewards_controller(contract_address = emission_manager)

    assert reward_controller = REWARDS_CONTROLLER

    return()
end

@external
func test_set_rewards_controller{syscall_ptr : felt*, range_check_ptr}():
    alloc_locals
    let (local emission_manager, local __, local rewards_controller_2) = get_contract_addresses()
    let (previous_reward_controller) = IEmissionManager.get_rewards_controller(contract_address = emission_manager)
    
    # Is Ownable working...?
    IEmissionManager.set_rewards_controller(contract_address = emission_manager, rewards_controller_ = rewards_controller_2)
    
    let (new_reward_controller) = IEmissionManager.get_rewards_controller(contract_address = emission_manager)

    assert new_reward_controller = rewards_controller_2

    return()
end

@external
func test_set_emission_admin{syscall_ptr : felt*, range_check_ptr}():
    alloc_locals
    let (local emission_manager, local __, local __) = get_contract_addresses()

    IEmissionManager.set_emission_admin(contract_address = emission_manager, reward = REWARD_1, admin = EMISSION_ADMIN)

    let (new_admin) = IEmissionManager.get_emission_admin(contract_address = emission_manager, reward = REWARD_1)

    assert new_admin = EMISSION_ADMIN

    return()
end