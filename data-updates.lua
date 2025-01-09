local reusable_robots = require("compatibilities.reusable_robots.reusable_robots")

if mods["Reusable_Robots"] then
    reusable_robots.ensure_data_compatibility()
end
