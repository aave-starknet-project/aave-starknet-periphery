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
const TRANSFER_STRATEGY = 555
const REWARD_ORACLE = 666
const ASSET = 777
const DISTRIBUTION_END = 888
const EMISSIONS_PER_SECOND = 999
const USER = 1111
const CLAIMER = 2222

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

func get_config_struct_array() -> (
    config_len : felt, config : RewardsDataTypes.RewardsConfigInput*
):
    alloc_locals
    let (
        local emission_manager, local rewards_controller_1, local rewards_controller_2
    ) = get_contract_addresses()

    local config_len = 2
    local config1 : RewardsDataTypes.RewardsConfigInput* = new RewardsDataTypes.RewardsConfigInput(emission_per_second=Uint256(0, 0), total_supply=Uint256(100, 0), distribution_end=DISTRIBUTION_END, asset_address=333, reward_address=rewards_controller_1, transfer_strategy=321, reward_oracle=888)
    local config2 : RewardsDataTypes.RewardsConfigInput* = new RewardsDataTypes.RewardsConfigInput(emission_per_second=Uint256(0, 0), total_supply=Uint256(100, 0), distribution_end=DISTRIBUTION_END, asset_address=334, reward_address=rewards_controller_2, transfer_strategy=322, reward_oracle=889)

    let (config : RewardsDataTypes.RewardsConfigInput*) = alloc()

    assert config[0] = [config1]
    assert config[1] = [config2]

    return (config_len, config)
end

func get_emissions_per_second() -> (
    rewards_len : felt,
    rewards : felt*,
    new_emissions_per_second_len : felt,
    new_emissions_per_second : felt*,
):
    alloc_locals
    let (
        local emission_manager, local rewards_controller_1, local rewards_controller_2
    ) = get_contract_addresses()

    let rewards_len = 2
    let (local rewards : felt*) = alloc()
    assert rewards[0] = rewards_controller_1
    assert rewards[1] = rewards_controller_2

    let new_emissions_per_second_len = 2
    let (local new_emissions_per_second : felt*) = alloc()
    assert new_emissions_per_second[0] = EMISSIONS_PER_SECOND
    assert new_emissions_per_second[1] = EMISSIONS_PER_SECOND

    return (rewards_len, rewards, new_emissions_per_second_len, new_emissions_per_second)
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

    let (local config_len, local config) = get_config_struct_array()

    %{ stop_prank_owner = start_prank(caller_address=ids.EMISSION_ADMIN, target_contract_address=ids.emission_manager) %}
    IEmissionManager.configure_assets(
        contract_address=emission_manager, config_len=config_len, config=config
    )
    %{ stop_prank_owner() %}

    # TODO
    # Get config calling rewards_controller contract and assert.

    return ()
end

@external
func test_set_transfer_strategy{syscall_ptr : felt*, range_check_ptr}():
    # TODO
    # A lot of this functions are very similar for various tests cases, abstract?
    alloc_locals
    let (
        local emission_manager, local rewards_controller_1, local rewards_controller_2
    ) = get_contract_addresses()

    %{ stop_prank_owner = start_prank(caller_address=ids.OWNER, target_contract_address=ids.emission_manager) %}
    IEmissionManager.set_emission_admin(
        contract_address=emission_manager, reward=rewards_controller_1, admin=EMISSION_ADMIN
    )
    %{ stop_prank_owner() %}

    %{ stop_prank_owner = start_prank(caller_address=ids.EMISSION_ADMIN, target_contract_address=ids.emission_manager) %}
    IEmissionManager.set_transfer_strategy(
        contract_address=emission_manager,
        reward=rewards_controller_1,
        transfer_strategy=TRANSFER_STRATEGY,
    )
    %{ stop_prank_owner() %}

    # TODO
    # Get transfer_strategy calling rewards_controller contract and assert.

    return ()
end

@external
func test_set_reward_oracle{syscall_ptr : felt*, range_check_ptr}():
    alloc_locals
    let (
        local emission_manager, local rewards_controller_1, local rewards_controller_2
    ) = get_contract_addresses()

    %{ stop_prank_owner = start_prank(caller_address=ids.OWNER, target_contract_address=ids.emission_manager) %}
    IEmissionManager.set_emission_admin(
        contract_address=emission_manager, reward=rewards_controller_1, admin=EMISSION_ADMIN
    )
    %{ stop_prank_owner() %}

    %{ stop_prank_owner = start_prank(caller_address=ids.EMISSION_ADMIN, target_contract_address=ids.emission_manager) %}
    IEmissionManager.set_reward_oracle(
        contract_address=emission_manager, reward=rewards_controller_1, reward_oracle=REWARD_ORACLE
    )
    %{ stop_prank_owner() %}

    # TODO
    # Get reward_oracle calling rewards_controller contract and assert.

    return ()
end

@external
func test_set_distribution_end{syscall_ptr : felt*, range_check_ptr}():
    alloc_locals
    let (
        local emission_manager, local rewards_controller_1, local rewards_controller_2
    ) = get_contract_addresses()

    %{ stop_prank_owner = start_prank(caller_address=ids.OWNER, target_contract_address=ids.emission_manager) %}
    IEmissionManager.set_emission_admin(
        contract_address=emission_manager, reward=rewards_controller_1, admin=EMISSION_ADMIN
    )
    %{ stop_prank_owner() %}

    %{ stop_prank_owner = start_prank(caller_address=ids.EMISSION_ADMIN, target_contract_address=ids.emission_manager) %}
    IEmissionManager.set_distribution_end(
        contract_address=emission_manager,
        asset=ASSET,
        reward=rewards_controller_1,
        new_distribution_end=DISTRIBUTION_END,
    )
    %{ stop_prank_owner() %}

    # TODO
    # Get distribution_end calling rewards_controller contract and assert.

    return ()
end

@external
func test_set_emission_per_second{syscall_ptr : felt*, range_check_ptr}():
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

    let (
        local rewards_len,
        local rewards,
        local new_emissions_per_second_len,
        local new_emissions_per_second,
    ) = get_emissions_per_second()

    %{ stop_prank_owner = start_prank(caller_address=ids.EMISSION_ADMIN, target_contract_address=ids.emission_manager) %}
    IEmissionManager.set_emission_per_second(
        contract_address=emission_manager,
        asset=ASSET,
        rewards_len=rewards_len,
        rewards=rewards,
        new_emissions_per_second_len=new_emissions_per_second_len,
        new_emissions_per_second=new_emissions_per_second,
    )
    %{ stop_prank_owner() %}

    # TODO
    # Get emission_per_second calling rewards_controller contract and assert.

    return ()
end

@external
func test_set_emission_manager{syscall_ptr : felt*, range_check_ptr}():
    alloc_locals
    let (local emission_manager, local __, local __) = get_contract_addresses()

    %{ stop_prank_owner = start_prank(caller_address=ids.OWNER, target_contract_address=ids.emission_manager) %}
    IEmissionManager.set_emission_manager(
        contract_address=emission_manager, emission_manager=EMISSION_MANAGER
    )
    %{ stop_prank_owner() %}

    # TODO
    # Assert from get_emission manager from rewards_controller.

    return ()
end

@external
func test_set_claimer{syscall_ptr : felt*, range_check_ptr}():
    alloc_locals
    let (
        local emission_manager, local rewards_controller_1, local rewards_controller_2
    ) = get_contract_addresses()

    # TODO
    # Use when set_claimer properly implemented in rewards_controller
    # %{ stop_prank_owner = start_prank(caller_address=ids.OWNER, target_contract_address=ids.emission_manager) %}
    # IEmissionManager.set_rewards_controller(
    #     contract_address=emission_manager, rewards_controller=rewards_controller_2
    # )
    # %{ stop_prank_owner() %}

    # %{ stop_prank_owner = start_prank(caller_address=ids.EMISSION_ADMIN, target_contract_address=ids.emission_manager) %}
    # IEmissionManager.set_emission_admin(
    #     contract_address=emission_manager, reward=rewards_controller_2, admin=OWNER
    # )
    # %{ stop_prank_owner() %}

    %{ stop_prank_owner = start_prank(caller_address=ids.OWNER, target_contract_address=ids.emission_manager) %}
    IEmissionManager.set_claimer(contract_address=emission_manager, user=USER, claimer=CLAIMER)
    %{ stop_prank_owner() %}

    # TODO
    # Get claimer calling rewards_controller contract and assert.

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
