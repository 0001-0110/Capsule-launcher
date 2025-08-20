local capsule_launcher_factory = require("prototypes.turrets.capsule_launcher_factory")
local ammo_category = require("prototypes.ammo_category")

data:extend({ ammo_category })
data:extend(capsule_launcher_factory.create_turret_prototypes())
