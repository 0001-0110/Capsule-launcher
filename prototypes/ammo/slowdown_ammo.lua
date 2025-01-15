local capsule_ammo = require("capsule_ammo")

local slowdown_ammo = {}

function slowdown_ammo.create_all_prototypes()
    return capsule_ammo.create_all_prototypes("slowdown", data.raw["projectile"]["slowdown-capsule"].action, data.raw["technology"]["military-3"])
end

return slowdown_ammo
