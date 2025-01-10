local reusable_robots = require("compatibilities.reusable_robots.data_updates")

if mods["Reusable_Robots"] then
    reusable_robots.ensure_data_compatibility()
end
