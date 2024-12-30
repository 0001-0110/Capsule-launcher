local utils = require("utils.utils")

local ammo_category = require("prototypes.ammo_category")
local capsules = require("prototypes.capsules.effect_capsule")
local defender_capsule = require("prototypes.capsules.defender_capsule")
local distractor_capsule = require("prototypes.capsules.distractor_capsule")
local destroyer_capsule = require("prototypes.capsules.destroyer_capsule")
local capsule_launcher = require("prototypes.turrets.capsule-launcher")

data:extend({ ammo_category, })
--data:extend(defender_capsule.prototypes)
data:extend(distractor_capsule.prototypes)
--data:extend(destroyer_capsule.prototypes)
data:extend(capsule_launcher.prototypes)
