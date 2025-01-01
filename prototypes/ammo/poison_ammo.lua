local capsule_ammo = require("capsule_ammo")

local projectile_action =
{
    type = "direct",
    action_delivery =
    {
        type = "instant",
        target_effects =
        {
            {
                type = "create-smoke",
                show_in_tooltip = true,
                entity_name = "poison-cloud",
                initial_height = 0
            },
            {
                type = "create-particle",
                particle_name = "poison-capsule-metal-particle",
                repeat_count = 8,
                initial_height = 1,
                initial_vertical_speed = 0.1,
                initial_vertical_speed_deviation = 0.05,
                offset_deviation = { {-0.1, -0.1}, {0.1, 0.1}, },
                speed_from_center = 0.05,
                speed_from_center_deviation = 0.01
            },
            {
                type = "invoke-tile-trigger",
                repeat_count = 1
            }
        }
    }
}

local poison_ammo = {}
capsule_ammo.create_all_prototypes(poison_ammo, "poison", projectile_action, data.raw["technology"]["military-3"])
return poison_ammo
