%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin

@storage_var
func _emisison_admins(reward : felt) -> (admin : felt):
end

@storage_var
func _rewards_controller() -> (address : felt):
end

@constructor
func constructor{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        rewards_controller : felt):
    _rewards_controller.write(rewards_controller)
    return ()
end
