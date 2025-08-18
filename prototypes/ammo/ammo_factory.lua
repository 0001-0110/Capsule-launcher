local utils = require("utils.utils")
local ammo_category = require("prototypes.ammo_category")

local based_on = "rocket"

local function create_item_prototype(name, projectile)
    local item = table.deepcopy(data.raw["ammo"][based_on])
    item.name = utils.prefix(name .. "-ammo")
    -- Set the ammo category to allow capsule launchers to use this as ammo
    item.ammo_category = ammo_category.name
    -- Set the projectile to fire when this item is used in the turret
    item.ammo_type = projectile
    return item
end

local function create_recipe_prototype(name, result_item)
    local recipe = table.deepcopy(data.raw["recipe"][based_on])
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
            name = name,
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

-- Update the existing technology effects to add the new recipe to unlock
local function update_technology(recipe, technology)
    table.insert(technology.effects, { type = "unlock-recipe", recipe = recipe.name, })
end

local ammo_factory = {}

--- @param capsule data.CapsulePrototype
--- @param technology data.TechnologyPrototype
--- @return data.Prototype[]
function ammo_factory.create_ammo_prototypes(capsule, technology)
    local projectile = capsule.capsule_action.attack_parameters.ammo_type
    item = create_item_prototype(capsule.name, projectile)
    recipe = create_recipe_prototype(capsule.name, item)
    update_technology(recipe, technology)
    return { item, recipe, }
end

return ammo_factory
