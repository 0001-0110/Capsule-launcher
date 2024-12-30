local utils = require("utils.utils")
local ammo_category = require("prototypes.ammo_category")

local BASED_ON = "rocket"

local function create_projectile_prototype(name, entity_count)
    local projectile = table.deepcopy(data.raw["projectile"][BASED_ON])
    projectile.name = utils.prefix(name .. "-projectile")
    -- Set the effect on impact
    -- Since the only effect is to create an entity, this projectile will deal no damage
    -- TODO Add more effects on impact (sounds, particles...)
    projectile.action.action_delivery =
    {
        type = "instant",
        target_effects =
        {
            {
                type = "create-entity",
                entity_name = name,
                -- TODO Change this according to entity count
                -- The number of offsets will dictate the number of entities created
                -- Each offset is a position relative to the impact point of the projectile
                offsets = { {0, 0}, {1, 1}, {1, -1}, }
            },
        },
    }
    return projectile
end

local function create_item_prototype(name, projectile)
    local item = table.deepcopy(data.raw["ammo"][BASED_ON])
    item.name = utils.prefix(name .. "-capsule")
    -- Set the ammo category to allow capsule launchers to use this as ammo
    item.ammo_category = ammo_category.name
    -- Set the projectile to fire when this item is used in the turret
    item.ammo_type.action.action_delivery.projectile = projectile.name
    return item
end

local function create_recipe_prototype(name, result_item)
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

local function create_technology_update(name, recipe)
    -- Return a function to avoid side effects
    return function (a)
        -- Update the existing technology effects to add the new recipe to unlock
        table.insert(data.raw["technology"][name].effects, { type = "unlock-recipe", recipe = recipe.name, })
    end
end

local combat_robot_capsule = {}

function combat_robot_capsule.create_all_prototypes(capsule, name, entity_count)
    capsule.projectile = create_projectile_prototype(name, entity_count)
    capsule.item = create_item_prototype(name, capsule.projectile)
    capsule.recipe = create_recipe_prototype(name, capsule.item)
    capsule.update_vanilla_technology = create_technology_update(name, capsule.recipe)
    capsule.prototypes = { capsule.item, capsule.recipe, capsule.projectile, }
end

return combat_robot_capsule
