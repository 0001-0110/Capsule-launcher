-- cl stands for capsule launcher
local PREFIX = "22_cl"

local utils = {}

-- Take the `count` first element of the given table
function utils.take(list, count)
    local result = {}
    for i = 1, math.min(count, #list) do
        table.insert(result, list[i])
    end
    return result
end

-- Add the mod prefix to the given string
function utils.prefix(name)
    return string.format("%s_%s", PREFIX, name)
end

return utils
