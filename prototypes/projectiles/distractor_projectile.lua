local utils = require("utils.utils")

local based_on = "rocket"

local distractor_capsule = {}

distractor_capsule.item = table.deepcopy(data.raw["ammo"][based_on])
distractor_capsule.item.name = utils.prefix("distractor-capsule")
distractor_capsule.item.ammo_category = utils.prefix("capsule")
distractor_capsule.item.ammo_type.action.action_delivery.projectile = utils.prefix("distractor-projectile")

distractor_capsule.recipe = table.deepcopy(data.raw["recipe"][based_on])
distractor_capsule.recipe.name = utils.prefix("distractor-capsule-recipe")
distractor_capsule.recipe.ingredients =
{
    {
        type = "item",
        name = "distractor-capsule",
        amount = 1,
    },
}
distractor_capsule.recipe.results =
{
    {
        type = "item",
        name = distractor_capsule.item.name,
        amount = 1,
    },
}

distractor_capsule.projectile = table.deepcopy(data.raw["projectile"][based_on])
distractor_capsule.projectile.name = utils.prefix("distractor-projectile")
distractor_capsule.projectile.action.action_delivery =
{
    type = "instant",
    target_effects =
    {
        {
            type = "create-entity",
            entity_name = "distractor",
            offsets = { {0, 0}, {1, 1}, {1, -1}, }
        },
    },
}

distractor_capsule.prototypes = { distractor_capsule.item, distractor_capsule.recipe, distractor_capsule.projectile, }
return distractor_capsule
