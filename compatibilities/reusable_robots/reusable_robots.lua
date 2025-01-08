local defender_ammo = require("prototypes.ammo.defender_ammo")
local destroyer_ammo = require("prototypes.ammo.defender_ammo")

local reusable_robots = {}

function reusable_robots.ensure_compatibility()

    table.insert(defender_ammo.custom_entity.destroy_action.action_delivery.source_effects, {  })

end

return reusable_robots
