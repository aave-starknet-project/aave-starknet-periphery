%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin

from contracts.interfaces.i_emission_manager import IEmissionManager

const OWNER = 111
const REWARDS_CONTROLLER = 222
const EMISSION_ADMIN = 333

@view
func __setup__{syscall_ptr : felt*, range_check_ptr}():
    %{
        context.emission_manager = deploy_contract("./contracts/rewards/base/emission_manager.cairo", [ids.OWNER, ids.REWARDS_CONTROLLER]).contract_address
    %}
    return ()
end

@external
func test_constructor{syscall_ptr : felt*, range_check_ptr}():
    return()
end

@external
func test_set_rewards_controller{syscall_ptr : felt*, range_check_ptr}():
    return()
end

@external
func test_set_emission_admin{syscall_ptr : felt*, range_check_ptr}():
    return()
end