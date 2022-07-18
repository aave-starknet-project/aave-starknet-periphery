%lang starknet

from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.uint256 import Uint256

from contracts.interfaces.i_emission_manager import IEmissionManager
from contracts.types.rewards_data import RewardsDataTypes

const OWNER = 111
const REWARDS_CONTROLLER = 222
const EMISSION_ADMIN = 333
const EMISSION_MANAGER = 444

@view
func __setup__{syscall_ptr : felt*, range_check_ptr}():
    %{
        context.rewards_controller_1 = deploy_contract("./contracts/rewards/rewards_controller.cairo", [ids.EMISSION_MANAGER]).contract_address
        context.rewards_controller_2 = deploy_contract("./contracts/rewards/rewards_controller.cairo", [ids.EMISSION_MANAGER]).contract_address
        context.emission_manager = deploy_contract("./contracts/rewards/emission_manager.cairo", [ids.OWNER, context.rewards_controller_1]).contract_address
    %}
    return ()
end

func get_contract_addresses() -> (
    emission_manager : felt, rewards_controller_1 : felt, rewards_controller_2 : felt
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

func get_config_structs() -> (
    config1 : RewardsDataTypes.RewardsConfigInput*, config2 : RewardsDataTypes.RewardsConfigInput*
):
    alloc_locals
    let (
        local emission_manager, local rewards_controller_1, local rewards_controller_2
    ) = get_contract_addresses()

    %{ print("Rewards 1:", ids.rewards_controller_1) %}
    %{ print("Rewards 2:", ids.rewards_controller_2) %}

    local config1 : RewardsDataTypes.RewardsConfigInput* = new RewardsDataTypes.RewardsConfigInput(emission_per_second=Uint256(0, 0), total_supply=Uint256(100, 0), distribution_end=222, asset_address=333, reward_address=rewards_controller_1, transfer_strategy=321, reward_oracle=888)
    local config2 : RewardsDataTypes.RewardsConfigInput* = new RewardsDataTypes.RewardsConfigInput(emission_per_second=Uint256(0, 0), total_supply=Uint256(100, 0), distribution_end=223, asset_address=334, reward_address=rewards_controller_2, transfer_strategy=322, reward_oracle=889)

    %{
        print("Reward1 in struct", ids.config1.reward_address)
        print("Reward2 in struct", ids.config2.reward_address)
    %}

    return (config1, config2)
end

@external
func test_constructor{syscall_ptr : felt*, range_check_ptr}():
    alloc_locals
    let (
        local emission_manager, local expected_rewards_controller, local __
    ) = get_contract_addresses()

    let (rewards_controller) = IEmissionManager.get_rewards_controller(
        contract_address=emission_manager
    )

    assert rewards_controller = expected_rewards_controller

    return ()
end

@external
func test_configure_assets{syscall_ptr : felt*, range_check_ptr}():
    alloc_locals
    let (
        local emission_manager, local rewards_controller_1, local rewards_controller_2
    ) = get_contract_addresses()

    %{ stop_prank_owner = start_prank(caller_address=ids.OWNER, target_contract_address=ids.emission_manager) %}
    IEmissionManager.set_emission_admin(
        contract_address=emission_manager, reward=rewards_controller_1, admin=EMISSION_ADMIN
    )
    IEmissionManager.set_emission_admin(
        contract_address=emission_manager, reward=rewards_controller_2, admin=EMISSION_ADMIN
    )
    %{ stop_prank_owner() %}

    let (local config1, local config2) = get_config_structs()
    let (config : RewardsDataTypes.RewardsConfigInput*) = alloc()
    assert config[0] = [config1]
    assert config[1] = [config2]

    %{ stop_prank_owner = start_prank(caller_address=ids.EMISSION_ADMIN, target_contract_address=ids.emission_manager) %}
    %{ print("Caller: ", ids.EMISSION_ADMIN) %}
    IEmissionManager.configure_assets(
        contract_address=emission_manager, config_len=2, config=config
    )
    %{ stop_prank_owner() %}

    return ()
end

@external
func test_set_transfer_strategy{syscall_ptr : felt*, range_check_ptr}():
    return ()
end

@external
func test_set_reward_oracle{syscall_ptr : felt*, range_check_ptr}():
    return ()
end

@external
func test_set_emission_per_second{syscall_ptr : felt*, range_check_ptr}():
    return ()
end

@external
func test_set_claimer{syscall_ptr : felt*, range_check_ptr}():
    return ()
end

@external
func test_set_rewards_controller{syscall_ptr : felt*, range_check_ptr}():
    alloc_locals
    let (
        local emission_manager, local rewards_controller_1, local rewards_controller_2
    ) = get_contract_addresses()

    %{ stop_prank_owner = start_prank(caller_address=ids.OWNER, target_contract_address=ids.emission_manager) %}
    IEmissionManager.set_rewards_controller(
        contract_address=emission_manager, rewards_controller=rewards_controller_2
    )
    %{ stop_prank_owner() %}

    let (new_reward_controller) = IEmissionManager.get_rewards_controller(
        contract_address=emission_manager
    )
    assert new_reward_controller = rewards_controller_2

    %{ expect_revert(error_message="Ownable") %}
    IEmissionManager.set_rewards_controller(
        contract_address=emission_manager, rewards_controller=rewards_controller_2
    )

    return ()
end

@external
func test_set_emission_admin{syscall_ptr : felt*, range_check_ptr}():
    alloc_locals
    let (local emission_manager, local __, local rewards_controller) = get_contract_addresses()

    %{ stop_prank_owner = start_prank(caller_address=ids.OWNER, target_contract_address=ids.emission_manager) %}
    IEmissionManager.set_emission_admin(
        contract_address=emission_manager, reward=rewards_controller, admin=EMISSION_ADMIN
    )
    %{ stop_prank_owner() %}

    let (new_admin) = IEmissionManager.get_emission_admin(
        contract_address=emission_manager, reward=rewards_controller
    )

    assert new_admin = EMISSION_ADMIN

    %{ expect_revert(error_message="Ownable") %}
    IEmissionManager.set_emission_admin(
        contract_address=emission_manager, reward=rewards_controller, admin=EMISSION_ADMIN
    )

    return ()
end
