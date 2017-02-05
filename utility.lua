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