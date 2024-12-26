local utils = require("utils.utils")

local based_on = "rocket"

local distractor_hive_capsule_item = table.deepcopy(data.raw["ammo"][based_on])
distractor_hive_capsule_item.name = utils.prefix("distractor-hive-capsule")
distractor_hive_capsule_item.ammo_category = utils.prefix("hive-capsule")
distractor_hive_capsule_item.ammo_type.action.action_delivery.projectile = "22_hl_distractor-hive-projectile"

local distractor_hive_capsule_recipe = table.deepcopy(data.raw["recipe"][based_on])
distractor_hive_capsule_recipe.name = utils.prefix("distractor-hive-capsule-recipe")
distractor_hive_capsule_recipe.results =
{
    {
        type = "item",
        name = distractor_hive_capsule_item.name,
        amount = 1,
    }
}

local distractor_hive_projectile = table.deepcopy(data.raw["projectile"][based_on])
distractor_hive_projectile.name = utils.prefix("distractor-hive-projectile")
distractor_hive_projectile.action.action_delivery =
{
    type = "instant",
    target_effects =
    {
        {
            type = "create-entity",
            entity_name = "distractor",
        },
    },
}

data:extend({ distractor_hive_capsule_item, distractor_hive_capsule_recipe, distractor_hive_projectile, })
