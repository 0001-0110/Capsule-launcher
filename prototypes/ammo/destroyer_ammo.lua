local combat_robot_ammo = require("combat_robot_ammo")

local destroyer_ammo = {}

function destroyer_ammo.create_all_prototypes()
    return combat_robot_ammo.create_all_prototypes("destroyer", 5)
end

return destroyer_ammo
