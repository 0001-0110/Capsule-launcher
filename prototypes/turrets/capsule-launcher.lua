local utils = require("utils.utils")

local BASED_ON = "rocket-turret"

local hive_launcher = {}

hive_launcher.entity = table.deepcopy(data.raw["ammo-turret"][BASED_ON])
hive_launcher.entity.name = utils.prefix("capsule-launcher-entity")
hive_launcher.entity.attack_parameters.ammo_category = utils.prefix("capsule")
hive_launcher.entity.attack_parameters.min_range = 0
hive_launcher.entity.attack_parameters.range = 50
hive_launcher.entity.prepare_range = hive_launcher.entity.attack_parameters.range * 1.1
hive_launcher.entity.attack_parameters.cooldown = 600

hive_launcher.item = table.deepcopy(data.raw["item"][BASED_ON])
hive_launcher.item.name = utils.prefix("capsule-launcher-item")
hive_launcher.item.place_result = hive_launcher.entity.name

hive_launcher.entity.minable.result = hive_launcher.item.name

hive_launcher.recipe = table.deepcopy(data.raw["recipe"][BASED_ON])
hive_launcher.recipe.name = utils.prefix("capsule-launcher-recipe")
hive_launcher.recipe.enabled = false
hive_launcher.recipe.ingredients =
{
    {
        type = "item",
        name = "steel-plate",
        amount = 20,
    },
    {
        type = "item",
        name = "iron-gear-wheel",
        amount = 20,
    },
    {
        type = "item",
        name = "advanced-circuit",
        amount = 4,
    },
    {
        type = "item",
        name = "engine-unit",
        amount = 20,
    },
}
hive_launcher.recipe.results =
{
    {
        type = "item",
        name = hive_launcher.item.name,
        amount = 1,
    }
}

hive_launcher.technology =
{
    type = "technology",
    name = utils.prefix("capsule-launcher-technology"),
    icon = "__capsule-launcher__/icons/logo_22.jpg",
    icon_size = 128,
    unit =
    {
        count = 200,
        ingredients =
        {
            {"automation-science-pack", 1},
            {"logistic-science-pack", 1},
            {"military-science-pack", 1},
            {"chemical-science-pack", 1},
        },
        time = 30,
    },
    effects =
    {
        {
            type = "unlock-recipe",
            recipe = hive_launcher.recipe.name,
        },
        -- TODO Unlock poison and slowdown capsules
    },
    prerequisites = { "military-3", },
}

hive_launcher.prototypes = { hive_launcher.entity, hive_launcher.item, hive_launcher.recipe, hive_launcher.technology, }
return hive_launcher
