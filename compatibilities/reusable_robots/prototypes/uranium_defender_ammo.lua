local combat_robot_ammo = require("prototypes.ammo.combat_robot_ammo")

local depleted_uranium_defender_ammo = {}
combat_robot_ammo.create_all_prototypes(depleted_uranium_defender_ammo, "uranium-defender", 1, data.raw["technology"]["uranium-ammo"])
return depleted_uranium_defender_ammo
