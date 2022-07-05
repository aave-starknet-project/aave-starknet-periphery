%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from contracts.interfaces.i_rewards_controller import IRewardsController

@external
func test_init_rewards_controller{
        syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}():
    alloc_locals
    local rewards_controller : felt
    %{ ids.rewards_controller = deploy_contract("./contracts/rewards/base/rewards_controller.cairo", [6]).contract_address %}

    let (manager) = IRewardsController.get_emission_manager(rewards_controller)

    assert manager = 6

    return ()
end
