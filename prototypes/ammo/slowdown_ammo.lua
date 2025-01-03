local capsule_ammo = require("capsule_ammo")

local slowdown_ammo = {}
capsule_ammo.create_all_prototypes(slowdown_ammo, "slowdown", data.raw["projectile"]["slowdown-capsule"].action, data.raw["technology"]["military-3"])
return slowdown_ammo
