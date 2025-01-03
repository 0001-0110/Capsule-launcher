local capsule_ammo = require("capsule_ammo")

local poison_ammo = {}
capsule_ammo.create_all_prototypes(poison_ammo, "poison", data.raw["projectile"]["poison-capsule"].action, data.raw["technology"]["military-3"])
return poison_ammo
