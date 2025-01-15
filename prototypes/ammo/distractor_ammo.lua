local combat_robot_ammo = require("combat_robot_ammo")

local distractor_ammo = {}

function distractor_ammo.create_all_prototypes()
    return combat_robot_ammo.create_all_prototypes("distractor", 3)
end

return distractor_ammo
