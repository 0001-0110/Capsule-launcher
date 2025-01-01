local combat_robot_ammo = require("combat_robot_ammo")

local defender_ammo = {}
combat_robot_ammo.create_all_prototypes(defender_ammo, "defender", 1)
return defender_ammo
