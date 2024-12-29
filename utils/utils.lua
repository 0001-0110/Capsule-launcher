-- cl stands for capsule launcher
local PREFIX = "22_cl"

local utils = {}

function utils.prefix(name)
    return string.format("%s_%s", PREFIX, name)
end

return utils
