local reusable_robots = require("compatibilities.reusable_robots.control")

-- Compatibilies with other mods --

if script.active_mods["Reusable_Robots"] then
    reusable_robots.ensure_control_compatibility()
end
