local utils = require("utils.utils")
local Stream = require("__toolbelt-22__.tools.stream")
local capsule_ammo_factory = require("prototypes.ammo.capsule_ammo_factory")
local combat_robot_ammo_factory = require("prototypes.ammo.combat_robot_ammo_factory")

--- @param capsule data.CapsulePrototype
local function is_throwable_capsule(capsule)
    return capsule.capsule_action.type == "throw"
end

--- @param capsule data.CapsulePrototype
local function is_combat_robot_capsule(capsule)
    local projectile = utils.get_projectile(capsule)
    return Stream.of(projectile.action):any(function(_, action)
        return Stream.of(action.action_delivery):any(function(_, action_delivery)
            return Stream.of(action_delivery.target_effects):any(function(_, effect)
                return utils.is_combat_robot_effect(effect)
            end)
        end)
    end)
end

for _, capsule_prototype in pairs(data.raw["capsule"]) do
    if is_throwable_capsule(capsule_prototype) then
        if is_combat_robot_capsule(capsule_prototype) then
            data:extend(combat_robot_ammo_factory.create_combat_robot_ammo_prototypes(capsule_prototype))
        else
            data:extend(capsule_ammo_factory.create_capsule_ammo_prototypes(capsule_prototype))
        end
    end
end
