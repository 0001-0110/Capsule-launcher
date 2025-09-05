local utils = require("utils.utils")
local capsule_launcher = require("prototypes.turrets.capsule_launcher")
local ammo_category = require("prototypes.ammo_category")

data:extend({ ammo_category })
data:extend(utils.to_array(capsule_launcher))
