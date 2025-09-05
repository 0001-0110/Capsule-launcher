local utils = require("utils.utils")
local Stream = require("__toolbelt-22__.tools.stream")
local ammo_category = require("prototypes.ammo_category")

local based_on = "rocket"

--- @param capsule data.CapsulePrototype
local function create_item_prototype(capsule, projectile)
    local item = table.deepcopy(data.raw["ammo"][based_on])
    item.name = utils.prefix(capsule.name .. "-ammo")
    item.localised_name = { "item-name.22_cl_capsule-ammo", { "item-name." .. capsule.name } }
    item.icon = capsule.icon
    -- Set the ammo category to allow capsule launchers to use this as ammo
    item.ammo_category = ammo_category.name
    -- Set the projectile to fire when this item is used in the turret
    item.ammo_type = projectile
    return item
end

local function create_recipe_prototype(name, result_item)
    local recipe = table.deepcopy(data.raw["recipe"][based_on])
    recipe.name = utils.prefix(name .. "-ammo")
    recipe.localised_name = { "recipe-name.22_cl_capsule-ammo", { "item-name." .. name } }
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

--- @param recipe data.RecipePrototype
--- @param effects data.Modifier[] | nil
local function get_effect_index(recipe, effects)
    return Stream.of(effects):first_or_default(function(_, effect)
        return effect.type == "unlock-recipe" and effect.recipe == recipe.name
    end)
end

--- @param recipe data.RecipePrototype
--- @param technology data.TechnologyPrototype
local function is_recipe_unlocked_by(recipe, technology)
    return get_effect_index(recipe, technology.effects) ~= nil
end

--- Recursively checks if the given recipe is unlocked by a technology or any of its prerequisites
--- @param recipe data.RecipePrototype
--- @param technology data.TechnologyPrototype
--- @param visited table<string, boolean> | nil
--- @return boolean
local function is_recipe_unlocked_in_tree(recipe, technology, visited)
    visited = visited or {}

    if visited[technology.name] then
        return visited[technology.name]
    end
    if is_recipe_unlocked_by(recipe, technology) then
        visited[technology.name] = true
        return true
    end

    for _, prerequisite in pairs(technology.prerequisites or {}) do
        if is_recipe_unlocked_in_tree(recipe, data.raw["technology"][prerequisite], visited) then
            visited[technology.name] = true
            return true
        end
    end

    visited[technology.name] = false
    return false
end

--- Returns all recipes that produce the given item, excluding those that also use the item as an ingredient
--- (like recycling recipes).
--- @param item data.ItemPrototype
--- @return Stream<number, data.RecipePrototype>
local function producing_recipes(item)
    return Stream.from(data.raw["recipe"]):where(function(_, recipe)
        return Stream.of(recipe.results):any(function(_, result)
            return result.name == item.name
        end) and not Stream.of(recipe.ingredients):any(function(_, ingredient)
            return ingredient.name == item.name
        end)
    end)
end

--- Update the existing technology effects to add the new recipe to unlock
--- @param capsule data.CapsulePrototype
--- @param new_recipe data.RecipePrototype
local function update_technologies(capsule, new_recipe)
    -- Add the capsule ammo to each technology that contains at least one recipe that allows you to craft the base
    -- capsule
    for _, recipe in producing_recipes(capsule):iterate() do
        for _, technology in pairs(data.raw["technology"]) do
            if technology.effects ~= nil then
                -- Check that the base capsule is unlocked by this technology, but that the capsule ammo recipe hasn't
                -- already been added (in cases where a single technology could unlock multiple alternate recipes for
                -- the capsule
                if is_recipe_unlocked_by(recipe, technology) and not is_recipe_unlocked_by(new_recipe, technology) then
                    table.insert(technology.effects, { type = "unlock-recipe", recipe = new_recipe.name })
                end
            end
        end
    end

    -- Remove the capsule ammo from all technologies where one required technology already has the same unlock recipe
    for _, technology in pairs(data.raw["technology"]) do
        for _, prerequisite in pairs(technology.prerequisites or {}) do
            if
                is_recipe_unlocked_by(new_recipe, technology)
                and is_recipe_unlocked_in_tree(new_recipe, data.raw["technology"][prerequisite])
            then
                table.remove(technology.effects, get_effect_index(new_recipe, technology))
            end
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
