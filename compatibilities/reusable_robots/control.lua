local utils = require("utils.utils")

local corpses = {}

local reusable_robots = {}

local function create_robot_corpse(event)
    local robot = event.robot
    -- Only trigger this when the robot that died comes from this mod
    if corpses[robot.name] then
        -- Drop the corpse on the ground
        robot.surface.spill_item_stack({
            position = robot.position,
            -- Select the correct corpse type for this type of robot
            stack = { name = corpses[robot.name] },
            -- Auto loot this item when a player walks on it
            enable_looted = true,
            -- Always mark this item for deconsruction
            force = robot.force,
        })
    end
end

function reusable_robots.ensure_control_compatibility()
    -- Fill the `corpses` dict, that will be used to link each robot with its correct corpse
    for key, _ in pairs(prototypes["entity"]) do
        if string.find(key, utils.prefix("idle-")) then
            -- Find the original name of the custom combat robot
            local original_name = utils.string_remove(key, utils.prefix("idle%-"))
            -- Link it to the correct corpse type
            corpses[key] = prototypes["item"][original_name .. "-corpse"]
        end
    end

    -- Create a corpse every time a robot dies
    script.on_event(defines.events.on_combat_robot_expired, create_robot_corpse)
end

return reusable_robots
