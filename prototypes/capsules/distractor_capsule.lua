local combat_robot_capsule = require("combat_robot_capsule")

local distractor_capsule = {}
combat_robot_capsule.create_all_prototypes(distractor_capsule, "distractor", 3)
return distractor_capsule
