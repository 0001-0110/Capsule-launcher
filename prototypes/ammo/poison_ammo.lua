local capsule_ammo = require("capsule_ammo")

local poison_ammo = {}

function poison_ammo.create_all_prototypes()
    return capsule_ammo.create_all_prototypes("poison", data.raw["projectile"]["poison-capsule"].action, data.raw["technology"]["military-3"])
end

return poison_ammo
