local combat_robot_ammo = require("combat_robot_ammo")

local destroyer_ammo = {}
combat_robot_ammo.create_all_prototypes(destroyer_ammo, "destroyer", 5)
return destroyer_ammo
