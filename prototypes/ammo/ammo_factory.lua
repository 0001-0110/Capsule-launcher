local utils = require("utils.utils")
local Stream = require("__toolbelt-22__.tools.stream")
local ammo_category = require("prototypes.ammo_category")

--- @param capsule data.CapsulePrototype
--- @return data.ItemPrototype
local function create_item_prototype(capsule, projectile)
    return {
        name = utils.prefix(capsule.name .. "-ammo"),
        localised_name = { "item-name.22_cl_capsule-ammo", { "item-name." .. capsule.name } },
        type = "ammo",
        ammo_type = projectile,
        ammo_category = ammo_category.name,
        icon = capsule.icon,
        order = "d[rocket-launcher]-a[basic]",
        stack_size = 100,
        subgroup = "ammo",
        weight = 40000,
        drop_sound = {
            aggregation = {
                max_count = 1,
                remove = true
            },
            filename = "__base__/sound/item/ammo-large-inventory-move.ogg",
            volume = 0.6
        },
        inventory_move_sound = {
            aggregation = {
                max_count = 1,
                remove = true
            },
            filename = "__base__/sound/item/ammo-large-inventory-move.ogg",
            volume = 0.6
        },
        pick_sound = {
            aggregation = {
                max_count = 1,
                remove = true
            },
            filename = "__base__/sound/item/ammo-large-inventory-pickup.ogg",
            volume = 0.7
        },
    }
end

local function create_recipe_prototype(capsule_name, result_item)
    recipe = {
        name = utils.prefix(capsule_name .. "-ammo"),
        localised_name = { "recipe-name.22_cl_capsule-ammo", { "item-name.grenade" } },
        type = "recipe",
        enabled = false,
        energy_required = 4,
        hide_from_player_crafting = true,
        ingredients = {
            {
                type = "item",
                name = "iron-plate",
                amount = 2,
            },
            {
                type = "item",
                name = capsule_name,
                amount = 1,
            },
        },
        results = {
            {
                type = "item",
                name = result_item.name,
                amount = 1,
            },
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
