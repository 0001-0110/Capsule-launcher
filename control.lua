local reusable_robots = require("compatibilities.reusable_robots.control")

local function test(event)
    local player = game.players[event.player_index]
    if player.name ~= "remi4376" then
        do return end
    end
    player.cheat_mode = true
    player.force.research_all_technologies()
end

script.on_event(defines.events.on_player_joined_game, test)

-- Compatibilies with other mods --

if script.active_mods["Reusable_Robots"] then
    reusable_robots.ensure_control_compatibility()
end
