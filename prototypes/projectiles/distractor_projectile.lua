local based_on = "rocket"

local distractor_hive_capsule = {}

distractor_hive_capsule.item = table.deepcopy(data.raw["ammo"][based_on])
distractor_hive_capsule.item.name = "22_hl_distractor-hive-capsule"
distractor_hive_capsule.item.ammo_category = "22_hl_hive-capsule"
distractor_hive_capsule.item.ammo_type.action.action_delivery.projectile = "22_hl_distractor-hive-projectile"

distractor_hive_capsule.recipe = table.deepcopy(data.raw["recipe"][based_on])
distractor_hive_capsule.recipe.name = "22_hl_distractor-hive-capsule-recipe"
distractor_hive_capsule.recipe.results =
{
    {
        type = "item",
        name = distractor_hive_capsule.item.name,
        amount = 1,
    }
}

distractor_hive_capsule.projectile = table.deepcopy(data.raw["projectile"][based_on])
distractor_hive_capsule.projectile.name = "22_hl_distractor-hive-projectile"
distractor_hive_capsule.projectile.action.action_delivery =
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

distractor_hive_capsule.prototypes = { distractor_hive_capsule.item, distractor_hive_capsule.recipe, distractor_hive_capsule.projectile, }
return distractor_hive_capsule
