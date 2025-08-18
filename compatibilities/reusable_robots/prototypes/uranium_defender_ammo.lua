local combat_robot_ammo = require("prototypes.ammo.combat_robot_ammo_factory")

local depleted_uranium_defender_ammo = {}

function depleted_uranium_defender_ammo.create_all_prototypes()
    return combat_robot_ammo.create_combat_robot_ammo_prototypes("uranium-defender", 1, data.raw["technology"]["uranium-ammo"])
end

return depleted_uranium_defender_ammo
