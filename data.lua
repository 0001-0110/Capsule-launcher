local utils = require("utils.utils")

local ammo_category = require("prototypes.ammo_category")
local effect_capsules = require("prototypes.capsules.effect_capsules")
local defender_capsule = require("prototypes.capsules.defender_capsule")
local distractor_capsule = require("prototypes.capsules.distractor_capsule")
local destroyer_capsule = require("prototypes.capsules.destroyer_capsule")
local capsule_launcher = require("prototypes.turrets.capsule-launcher")

local function load(machin)
    machin.update_vanilla_technology()
    data:extend(machin.prototypes)
end

data:extend({ ammo_category, })

--load(effect_capsules)
--load(defender_capsule)
load(distractor_capsule)
--load(destroyer_capsule)

data:extend(capsule_launcher.prototypes)
