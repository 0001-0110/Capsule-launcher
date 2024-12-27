local based_on = "rocket"

local distractor_hive_capsule_item = table.deepcopy(data.raw["ammo"][based_on])
distractor_hive_capsule_item.name = "22_hl_distractor-hive-capsule"
distractor_hive_capsule_item.ammo_category = "22_hl_hive-capsule"
distractor_hive_capsule_item.ammo_type.action.action_delivery.projectile = "22_hl_distractor-hive-projectile"

local distractor_hive_capsule_recipe = table.deepcopy(data.raw["recipe"][based_on])
distractor_hive_capsule_recipe.name = "22_hl_distractor-hive-capsule-recipe"
distractor_hive_capsule_recipe.results =
{
    {
        type = "item",
        name = distractor_hive_capsule_item.name,
        amount = 1,
    }
}

local distractor_hive_projectile = table.deepcopy(data.raw["projectile"][based_on])
distractor_hive_projectile.name = "22_hl_distractor-hive-projectile"
distractor_hive_projectile.action.action_delivery =
{
    type = "instant",
    target_effects =
    {
        {
            type = "create-entity",
            entity_name = "distractor",
            offsets = { {0, 0}, {1, 1}, {1, 0}, }
        },
    },
}

data:extend({ distractor_hive_capsule_item, distractor_hive_capsule_recipe, distractor_hive_projectile, })
