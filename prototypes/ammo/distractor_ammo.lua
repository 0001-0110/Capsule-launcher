local combat_robot_ammo = require("combat_robot_ammo")

local distractor_ammo = {}
combat_robot_ammo.create_all_prototypes(distractor_ammo, "distractor", 3)
return distractor_ammo
