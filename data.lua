local utils = require("utils.utils")

data:extend({
    {
        type = "ammo-category",
        name = utils.prefix("hive-capsule")
    }
})

require("prototypes.projectiles.defender_projectile")
require("prototypes.projectiles.distractor_projectile")
require("prototypes.projectiles.destroyer_projectile")

require("prototypes.turrets.hive-launcher")
