local capsule_launcher_factory = require("prototypes.turrets.capsule_launcher_factory")
local capsule_ammo_factory = require("prototypes.ammo.capsule_ammo_factory")

local ammo_category = require("prototypes.ammo_category")

data:extend({ ammo_category, })

data:extend(capsule_launcher_factory.create_turret_prototypes())

data:extend(capsule_ammo_factory.create_capsule_ammo_prototypes(data.raw["capsule"]["poison-capsule"]))
data:extend(capsule_ammo_factory.create_capsule_ammo_prototypes(data.raw["capsule"]["slowdown-capsule"]))
