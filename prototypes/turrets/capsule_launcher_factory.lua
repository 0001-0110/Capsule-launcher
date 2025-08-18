local utils = require("utils.utils")
local capsule_launcher_dataset = require("prototypes.turrets.capsule_launcher_dataset")

capsule_launcher_utils = {}

local function update_technology(recipe, technology)
    table.insert(technology.effects, { type = "unlock-recipe", recipe = recipe.name, })
end

local function create_ammo_prototypes(technology)
    local prototypes = {}

    update_technology(prototypes.recipe, technology)
    return prototypes
end

function capsule_launcher_utils.create_turret_prototypes()
    return {
        utils.create_prototype(capsule_launcher_dataset.entity_data),
        utils.create_prototype(capsule_launcher_dataset.item_data),
        utils.create_prototype(capsule_launcher_dataset.recipe_data),
        capsule_launcher_dataset.technology_prototype,
    }
end

function capsule_launcher_utils.create_combat_robot_ammo_prototypes(capsule_ammo_data)
    local technology = data.raw["technology"][capsule_ammo_data.name]
    return create_ammo_prototypes(technology)
end

return capsule_launcher_utils
