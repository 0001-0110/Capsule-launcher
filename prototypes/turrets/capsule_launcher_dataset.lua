local utils = require("utils.utils")
local ammo_category = require("prototypes.ammo_category")

local based_on = "rocket-turret"

local capsule_launcher_dataset = {}

capsule_launcher_dataset.entity_data = {
    type = "ammo-turret",
    based_on = "rocket-turret",
    name = utils.prefix("capsule-launcher-entity"),
    attack_parameters = {
        ammo_category = ammo_category.name,
        min_range = 0,
        range = 50,
        cooldown = 600,
    },
    prepare_range = 55,
    surface_conditions = { { property = "gravity", min = 0.1, } },
}

capsule_launcher_dataset.item_data = {
    type = "item",
    based_on = based_on,
    name = utils.prefix("capsule-launcher-item"),
    place_result = capsule_launcher_dataset.entity_data.name,
}

capsule_launcher_dataset.entity_data.minable = { result = capsule_launcher_dataset.item_data.name }

capsule_launcher_dataset.recipe_data = {
    type = "recipe",
    based_on = based_on,
    name = utils.prefix("capsule-launcher-recipe"),
    enabled = false,
    ingredients = {
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
            name = "engine-unit",
            amount = 20,
        },
        {
            type = "item",
            name = "advanced-circuit",
            amount = 4,
        },
        {
            type = "item",
            name = "rocket-launcher",
            amount = 4,
        },
    },
    results = {
        {
            type = "item",
            name = capsule_launcher_dataset.item_data.name,
            amount = 1,
        },
    },
}

capsule_launcher_dataset.technology_prototype = {
    type = "technology",
    name = utils.prefix("capsule-launcher-technology"),
    icon = "__space-age__/graphics/technology/rocket-turret.png",
    icon_size = 256,
    unit = {
        count = 200,
        ingredients =
        {
            { "automation-science-pack", 1 },
            { "logistic-science-pack", 1 },
            { "military-science-pack", 1 },
            { "chemical-science-pack", 1 },
        },
        time = 30,
    },
    effects = {
        {
            type = "unlock-recipe",
            recipe = capsule_launcher_dataset.recipe_data.name,
        },
    },
    prerequisites = { "rocketry" },
}

return capsule_launcher_dataset
