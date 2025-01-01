local capsule_ammo = require("capsule_ammo")

local projectile_action =
{
    type = "area",
    radius = 11,
    force = "enemy",
    action_delivery =
    {
        type = "instant",
        target_effects =
        {
            {
                type = "create-sticker",
                sticker = "slowdown-sticker"
            }
        }
    }
}

local slowdown_ammo = {}
capsule_ammo.create_all_prototypes(slowdown_ammo, "slowdown", projectile_action, data.raw["technology"]["military-3"])
return slowdown_ammo
