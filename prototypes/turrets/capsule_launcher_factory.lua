local utils = require("utils.utils")
local capsule_launcher_dataset = require("prototypes.turrets.capsule_launcher_dataset")

local capsule_launcher_utils = {}

function capsule_launcher_utils.create_turret_prototypes()
    return {
        utils.create_prototype(capsule_launcher_dataset.entity_data),
        utils.create_prototype(capsule_launcher_dataset.item_data),
        utils.create_prototype(capsule_launcher_dataset.recipe_data),
        capsule_launcher_dataset.technology_prototype,
    }
end

return capsule_launcher_utils
