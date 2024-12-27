local utils = require("utils.utils")

local BASED_ON = "rocket-turret"

local hive_launcher = {}

hive_launcher.entity = table.deepcopy(data.raw["ammo-turret"][BASED_ON])
hive_launcher.entity.name = utils.prefix("hive-launcher-entity")
hive_launcher.entity.attack_parameters.ammo_category = utils.prefix("hive-capsule")
hive_launcher.entity.attack_parameters.range = 50
hive_launcher.entity.attack_parameters.min_range = 0
hive_launcher.entity.attack_parameters.cooldown = 600

hive_launcher.item = table.deepcopy(data.raw["item"][BASED_ON])
hive_launcher.item.name = utils.prefix("hive-launcher-item")
hive_launcher.item.place_result = hive_launcher.entity.name

hive_launcher.entity.minable.result = hive_launcher.item.name

hive_launcher.recipe = table.deepcopy(data.raw["recipe"][BASED_ON])
hive_launcher.recipe.name = utils.prefix("hive-launcher-recipe")
hive_launcher.recipe.enabled = true
hive_launcher.recipe.results =
{
    {
        type = "item",
        name = hive_launcher.item.name,
        amount = 1,
    }
}

hive_launcher.prototypes = { hive_launcher.entity, hive_launcher.item, hive_launcher.recipe, }
return hive_launcher
