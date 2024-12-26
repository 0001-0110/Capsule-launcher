local utils = require("utils.utils")

local based_on = "rocket-turret"

local hive_launcher_entity = table.deepcopy(data.raw["ammo-turret"][based_on])
hive_launcher_entity.name = utils.prefix("hive-launcher-entity")
hive_launcher_entity.attack_parameters.ammo_category = utils.prefix("hive-capsule")

local hive_launcher_item = table.deepcopy(data.raw["item"][based_on])
hive_launcher_item.name = utils.prefix("hive-launcher-item")
hive_launcher_item.place_result = hive_launcher_entity.name

hive_launcher_entity.minable.result = hive_launcher_item.name

local hive_launcher_recipe = table.deepcopy(data.raw["recipe"][based_on])
hive_launcher_recipe.name = utils.prefix("hive-launcher-recipe")
hive_launcher_recipe.enabled = true
hive_launcher_recipe.results =
{
    {
        type = "item",
        name = hive_launcher_item.name,
        amount = 1,
    }
}

data:extend({ hive_launcher_entity, hive_launcher_item, hive_launcher_recipe })
