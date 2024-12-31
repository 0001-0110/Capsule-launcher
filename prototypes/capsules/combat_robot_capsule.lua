local utils = require("utils.utils")
local ammo_category = require("prototypes.ammo_category")

local BASED_ON = "rocket"

-- Create a custom combat robot that do not follow its owner
local function create_custom_combat_robot(name)
    local custom_combat_robot = table.deepcopy(data.raw["combat-robot"][name])
    custom_combat_robot.name = utils.prefix(name)
    custom_combat_robot.follows_player = false
    return custom_combat_robot
end

local function create_projectile_prototype(name, entity_count, custom_combat_robot)
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
                entity_name = custom_combat_robot and custom_combat_robot.name or name,
                -- TODO This can only work for up to three entities, find a more generic solution
                -- The number of offsets will dictate the number of entities created
                -- Each offset is a position relative to the impact point of the projectile
                offsets = utils.take({ {0, 0}, {1, 1}, {1, -1}, }, entity_count)
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
    return function ()
        -- Update the existing technology effects to add the new recipe to unlock
        table.insert(data.raw["technology"][name].effects, { type = "unlock-recipe", recipe = recipe.name, })
    end
end

local combat_robot_capsule = {}

function combat_robot_capsule.create_all_prototypes(capsule, name, entity_count)
    capsule.prototypes = {}

    -- Combat robots shouldn't go back to the turret that shot them, so we create a custom combat robot that doesn't
    -- follow its owner
    if data.raw["combat-robot"][name].follows_player then
        capsule.custom_combat_robot = create_custom_combat_robot(name)
        table.insert(capsule.prototypes, capsule.custom_combat_robot)
    end

    capsule.projectile = create_projectile_prototype(name, entity_count, capsule.custom_combat_robot)
    table.insert(capsule.prototypes, capsule.projectile)
    capsule.item = create_item_prototype(name, capsule.projectile)
    table.insert(capsule.prototypes, capsule.item)
    capsule.recipe = create_recipe_prototype(name, capsule.item)
    table.insert(capsule.prototypes, capsule.recipe)
    capsule.update_vanilla_technology = create_technology_update(name, capsule.recipe)
end

return combat_robot_capsule
