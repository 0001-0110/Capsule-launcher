local utils = require("utils.utils")

data:extend({
    {
        type = "ammo-category",
        name = utils.prefix("hive-capsule")
    }
})

-- data:extend(require("prototypes.projectiles.defender_projectile").prototypes)
data:extend(require("prototypes.projectiles.distractor_projectile").prototypes)
-- data:extend(require("prototypes.projectiles.destroyer_projectile").prototypes)

data:extend(require("prototypes.turrets.hive-launcher").prototypes)
