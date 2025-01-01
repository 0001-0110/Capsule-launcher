local utils = require("utils.utils")
local ammo_category = require("prototypes.ammo_category")

local BASED_ON = "rocket"

local function create_projectile_prototype(name, action)
    local projectile = table.deepcopy(data.raw["projectile"][BASED_ON])
    projectile.name = utils.prefix(name .. "-ammo-projectile")
    -- Set the effect on impact
    projectile.action = action
    return projectile
end

local function create_item_prototype(name, projectile)
    local item = table.deepcopy(data.raw["ammo"][BASED_ON])
    item.name = utils.prefix(name .. "-ammo")
    -- Set the ammo category to allow capsule launchers to use this as ammo
    item.ammo_category = ammo_category.name
    -- Set the projectile to fire when this item is used in the turret
    item.ammo_type.action.action_delivery.projectile = projectile.name
    return item
end

local function create_recipe_prototype(name, result_item)
    local recipe = table.deepcopy(data.raw["recipe"][BASED_ON])
    recipe.name = utils.prefix(name .. "-ammo-recipe")
    recipe.ingredients =
    {
        {
            type = "item",
            name = "iron-plate",
            amount = 2,
        },
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

local function create_technology_update(recipe, technology)
    -- Return a function to avoid side effects
    -- This function will then be invoked in data.lua
    return function ()
        -- Update the existing technology effects to add the new recipe to unlock
        table.insert(technology.effects, { type = "unlock-recipe", recipe = recipe.name, })
    end
end

local capsule_ammo = {}

function capsule_ammo.create_all_prototypes(capsule, name, projectile_action, technology)
    -- If this is a combat robot capsule, `prototypes` has already been initialized and may contain values. It should
    -- only be replaced by a new table if it is nil
    capsule.prototypes = capsule.prototypes or {}

    capsule.projectile = create_projectile_prototype(name, projectile_action)
    table.insert(capsule.prototypes, capsule.projectile)
    capsule.item = create_item_prototype(name, capsule.projectile)
    table.insert(capsule.prototypes, capsule.item)
    capsule.recipe = create_recipe_prototype(name, capsule.item)
    table.insert(capsule.prototypes, capsule.recipe)
    capsule.update_vanilla_technology = create_technology_update(capsule.recipe, technology)
end

return capsule_ammo
