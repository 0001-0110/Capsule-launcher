data:extend({
    {
        type = "ammo-category",
        name = "22_hl_hive-capsule"
    }
})

require("prototypes.projectiles.defender_projectile")
require("prototypes.projectiles.distractor_projectile")
require("prototypes.projectiles.destroyer_projectile")

data:extend(require("prototypes.turrets.hive-launcher").prototypes)
