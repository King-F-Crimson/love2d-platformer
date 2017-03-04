function math.sign(x)
    if x < 0 then
        return -1
    elseif x>0 then
        return 1
    else
        return 0
    end
end

function apply_to_all(table, operation)
    for k, v in pairs(table) do
        operation(k, v, table)
    end
end

function deepcopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[deepcopy(orig_key)] = deepcopy(orig_value)
        end
        setmetatable(copy, deepcopy(getmetatable(orig)))
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end

-- This assumes origin is top left.
function center(obj_length, container_length, scale)
    return (container_length / 2 - obj_length) / scale
end