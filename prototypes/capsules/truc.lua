local utils = require("utils.utils")
local ammo_category = require("prototypes.ammo_category")

local BASED_ON = "rocket"

local truc = {}

function truc.create_all_prototypes(capsule, name, entity_count)
    capsule.projectile = truc.create_projectile_prototype(name, entity_count)
    capsule.item = truc.create_item_prototype(name, capsule.projectile)
    capsule.recipe = truc.create_recipe_prototype(name, capsule.item)
    capsule.prototypes = { capsule.item, capsule.recipe, capsule.projectile, }
end

function truc.create_projectile_prototype(name, entity_count)
    local projectile = table.deepcopy(data.raw["projectile"][BASED_ON])
    projectile.name = utils.prefix(name .. "-projectile")
    projectile.action.action_delivery =
    {
        type = "instant",
        target_effects =
        {
            {
                type = "create-entity",
                entity_name = name,
                -- TODO Change this according to entity count
                offsets = { {0, 0}, {1, 1}, {1, -1}, }
            },
        },
    }
    return projectile
end

function truc.create_item_prototype(name, projectile)
    local item = table.deepcopy(data.raw["ammo"][BASED_ON])
    item.name = utils.prefix(name .. "-capsule")
    item.ammo_category = ammo_category.name
    item.ammo_type.action.action_delivery.projectile = projectile.name
    return item
end

function truc.create_recipe_prototype(name, result_item)
    local recipe = table.deepcopy(data.raw["recipe"][BASED_ON])
    recipe.name = utils.prefix(name .. "-capsule-recipe")
    recipe.ingredients =
    {
        {
            type = "item",
            name = name .. "-capsule",
            amount = 1,
        },
    }
    recipe.results =
    {
        {
            type = "item",
            name = result_item.name,
            amount = 1,
        },
    }
    return recipe
end

return truc
