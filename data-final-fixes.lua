local combat_robot_ammo_factory = require("prototypes.ammo.combat_robot_ammo_factory")

--- @param capsule data.CapsulePrototype
local function is_throwable_capsule(capsule)
    -- TODO replace temp workaround by real check
    return capsule.name == "defender-capsule" or capsule.name == "distractor-capsule" or capsule.name == "destroyer-capsule"
end

--- @param capsule data.CapsulePrototype
local function is_combat_robot_capsule(capsule)
    return true
end

for _, capsule_prototype in pairs(data.raw["capsule"]) do
    if is_throwable_capsule(capsule_prototype) then
        if is_combat_robot_capsule(capsule_prototype) then
            data:extend(combat_robot_ammo_factory.create_combat_robot_ammo_prototypes(capsule_prototype))
        else
        end
    end
end
