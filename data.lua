local ammo_category = require("prototypes.ammo_category")
local capsule_launcher = require("prototypes.turrets.capsule-launcher")
local poison_ammo = require("prototypes.ammo.poison_ammo")
local slowdown_ammo = require("prototypes.ammo.slowdown_ammo")
local defender_ammo = require("prototypes.ammo.defender_ammo")
local distractor_ammo = require("prototypes.ammo.distractor_ammo")
local destroyer_ammo = require("prototypes.ammo.destroyer_ammo")

local function load(capsule)
    capsule.update_technology()
    data:extend(capsule.prototypes)
end

-- Add the new ammo category
data:extend({ ammo_category, })

-- Load all prototypes related to the capsule launcher
data:extend(capsule_launcher.prototypes)

-- Load all prototypes for the different ammo that can be used inside the capsule launcher
load(poison_ammo)
load(slowdown_ammo)
load(defender_ammo)
load(distractor_ammo)
load(destroyer_ammo)
