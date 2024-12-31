local utils = require("utils.utils")

local ammo_category = require("prototypes.ammo_category")
local effect_capsules = require("prototypes.capsules.effect_capsules")
local defender_capsule = require("prototypes.capsules.defender_capsule")
local distractor_capsule = require("prototypes.capsules.distractor_capsule")
local destroyer_capsule = require("prototypes.capsules.destroyer_capsule")
local capsule_launcher = require("prototypes.turrets.capsule-launcher")

local function load(capsule)
    capsule.update_vanilla_technology()
    data:extend(capsule.prototypes)
end

-- Add the new ammo category
data:extend({ ammo_category, })

-- Load all prototypes related to the capsule launcher
data:extend(capsule_launcher.prototypes)

-- Load all prototypes for the different ammo that can be used inside the capsule launcher
--load(effect_capsules)
load(defender_capsule)
load(distractor_capsule)
load(destroyer_capsule)
