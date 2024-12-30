local combat_robot_capsule = require("combat_robot_capsule")

local destroyer_capsule = {}
combat_robot_capsule.create_all_prototypes(destroyer_capsule, "destroyer", 3)
return destroyer_capsule
