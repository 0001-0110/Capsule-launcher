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
    recipe.ingredients = {
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
    recipe.results = {
        {
            type = "item",
            name = result_item.name,
            amount = 1,
        },
    }
    return recipe
end

local function machin(technology, recipe)
    for effect_index, effect in pairs(technology.effects or {}) do
        if effect.type == "unlock-recipe" and effect.recipe == recipe.name then
            return effect_index
        end
    end
    return false
end

local function truc(technology, recipe, root)
    if not root and machin(technology, recipe) then
        return true
    end

    local count = 0
    for _, effect in pairs(technology.effects or {}) do
        if effect.type == "unlock-recipe" and effect.recipe == recipe.name then
            count = count + 1
        end
    end
    if count > 1 then
        return true
    end

    for _, prerequisite in pairs(technology.prerequisites or {}) do
        if truc(data.raw["technology"][prerequisite], recipe, false) then
            return true
        end
    end
    return false
end

--- Update the existing technology effects to add the new recipe to unlock
--- @param capsule data.CapsulePrototype
--- @param new_recipe data.RecipePrototype
local function update_technologies(capsule, new_recipe)
    -- Add the capsule ammo to each technology that contains at least one recipe that allows you to craft the base
    -- capsule
    for _, recipe in pairs(data.raw["recipe"]) do
        if recipe.results ~= nil then
            for _, result in pairs(recipe.results) do
                if result.name == capsule.name then
                    for _, technology in pairs(data.raw["technology"]) do
                        if technology.effects ~= nil then
                            if machin(technology, recipe) then
                                table.insert(technology.effects, { type = "unlock-recipe", recipe = new_recipe.name })
                            end
                        end
                    end
                end
            end
        end
    end

    -- Remove the capsule ammo from all technologies where one required technology already has the same unlock recipe
    for _, technology in pairs(data.raw["technology"]) do
        if machin(technology, new_recipe) and truc(technology, new_recipe, true) then
            table.remove(technology.effects, machin(technology, new_recipe))
        end
    end
end

local ammo_factory = {}

--- @param capsule data.CapsulePrototype
--- @return data.Prototype[]
function ammo_factory.create_ammo_prototypes(capsule)
    local projectile = capsule.capsule_action.attack_parameters.ammo_type
    local item = create_item_prototype(capsule, projectile)
    local recipe = create_recipe_prototype(capsule.name, item)
    update_technologies(capsule, recipe)
    return { item, recipe }
end

return ammo_factory
