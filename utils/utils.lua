-- hl stands for hive launcher
local PREFIX = "22_hl"

local utils = {}

function utils.prefix(name)
    return string.format("%s_%s", PREFIX, name)
end

return utils
