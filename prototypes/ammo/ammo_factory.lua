local utils = require("utils.utils")
local ammo_category = require("prototypes.ammo_category")

local based_on = "rocket"

--- @param capsule data.CapsulePrototype
local function create_item_prototype(capsule, projectile)
    local item = table.deepcopy(data.raw["ammo"][based_on])
    item.name = utils.prefix(capsule.name .. "-ammo")
    item.icon = capsule.icon
    -- Set the ammo category to allow capsule launchers to use this as ammo
    item.ammo_category = ammo_category.name
    -- Set the projectile to fire when this item is used in the turret
    item.ammo_type = projectile
    return item
end

local function create_recipe_prototype(name, result_item)
    local recipe = table.deepcopy(data.raw["recipe"][based_on])
    recipe.name = utils.prefix(name .. "-ammo-recipe")
    recipe.hide_from_player_crafting = true
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

--- Update the existing technology effects to add the new recipe to unlock
--- @param capsule data.CapsulePrototype
--- @param new_recipe data.RecipePrototype
local function update_technology(capsule, new_recipe)
    -- TODO These two loops are really similar, some factorization would be nice

    local capsule_recipe = nil
    for _, recipe in pairs(data.raw["recipe"]) do
        -- We are searching for the real recipes, so we ignore recycling recipes that are not linked with any technology
        if not string.match(recipe.name, "recycling") and recipe.results ~= nil then
            for _, result in pairs(recipe.results) do
                if result.name == capsule.name then
                    capsule_recipe = recipe
                end
            end
        end
    end
    if capsule_recipe == nil then
        error()
    end
    log(capsule.name)
    log(capsule_recipe.name)

    local capsule_technology = nil
    for _, technology in pairs(data.raw["technology"]) do
        if technology.effects ~= nil then
            for _, effect in pairs(technology.effects) do
                if effect.type == "unlock-recipe" and effect.recipe == capsule_recipe.name then
                    capsule_technology = technology
                end
            end
        end
    end
    if capsule_technology == nil then
        error()
    end

    table.insert(capsule_technology.effects, { type = "unlock-recipe", recipe = new_recipe.name, })
end

local ammo_factory = {}

--- @param capsule data.CapsulePrototype
--- @return data.Prototype[]
function ammo_factory.create_ammo_prototypes(capsule)
    local projectile = capsule.capsule_action.attack_parameters.ammo_type
    item = create_item_prototype(capsule, projectile)
    recipe = create_recipe_prototype(capsule.name, item)
    update_technology(capsule, recipe)
    return { item, recipe, }
end

return ammo_factory
