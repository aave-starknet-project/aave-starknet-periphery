%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from contracts.interfaces.i_rewards_controller import IRewardsController

const EMISSION_MANAGER = 6

@view
func __setup__{syscall_ptr : felt*, range_check_ptr}():
    %{ context.rewards_controller = deploy_contract("./contracts/rewards/rewards_controller.cairo", [ids.EMISSION_MANAGER]).contract_address %}
    return ()
end

@external
func test_init_rewards_controller{
    syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
}():
    alloc_locals
    local rewards_controller : felt

    %{ ids.rewards_controller = context.rewards_controller %}

    let (manager) = IRewardsController.get_emission_manager(rewards_controller)

    assert manager = EMISSION_MANAGER

    return ()
end
