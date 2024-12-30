local combat_robot_capsule = require("capsule-launcher.prototypes.capsules.combat_robot_capsule")

local defender_capsule = {}
combat_robot_capsule.create_all_prototypes(defender_capsule, "defender", 1)
return defender_capsule
