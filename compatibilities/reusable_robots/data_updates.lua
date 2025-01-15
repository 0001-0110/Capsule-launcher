local depleted_uranium_defender_ammo = require("prototypes.uranium_defender_ammo")

local reusable_robots = {}

function reusable_robots.ensure_data_compatibility()
    -- TODO Don't do this at home kids, I'll fix it later
    local depleted_uranium_defender_ammo = depleted_uranium_defender_ammo.create_all_prototypes()
    -- Create uranium defender ammo, and custom entity
    data:extend(depleted_uranium_defender_ammo.prototypes)
    -- Add the ammo to the tech tree
    depleted_uranium_defender_ammo.update_technology()
end

return reusable_robots
