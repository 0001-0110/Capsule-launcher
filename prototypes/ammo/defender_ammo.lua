local combat_robot_ammo = require("combat_robot_ammo")

local defender_ammo = {}

function defender_ammo.create_all_prototypes()
    return combat_robot_ammo.create_all_prototypes("defender", 1)
end

return defender_ammo
