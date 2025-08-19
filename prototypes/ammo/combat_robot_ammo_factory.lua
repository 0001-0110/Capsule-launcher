local utils = require("utils.utils")
local ammo_factory = require("prototypes.ammo.ammo_factory")

--- @param projectile data.ProjectilePrototype
local function get_combat_robot_prototype(projectile)
    local combat_robot_name = utils.first(projectile.action.action_delivery.target_effects, utils.is_combat_robot_effect).entity_name
    return data.raw["combat-robot"][combat_robot_name]
end

--- Create a custom combat robot that stays idle.
--- Setting the `follows_player` to false is not enough, because that causes the robots to drift aimlessly.
--- @param combat_robot data.CombatRobotPrototype
local function create_idle_combat_robot(combat_robot)
    local custom_combat_robot = table.deepcopy(combat_robot)
    custom_combat_robot.name = utils.prefix("idle-" .. combat_robot.name)
    custom_combat_robot.max_speed = 0
    return custom_combat_robot
end

--- Change the projectile to spawn the idle combat robot instead of the normal one
--- @param projectile data.ProjectilePrototype
--- @param combat_robot data.CombatRobotPrototype
local function update_projectile_combat_robot(projectile, combat_robot)
    utils.first(projectile.action.action_delivery.target_effects, utils.is_combat_robot_effect).entity_name = combat_robot.name
end

local combat_robot_ammo_factory = {}

--- @param combat_robot_capsule data.CapsulePrototype
function combat_robot_ammo_factory.create_combat_robot_ammo_prototypes(combat_robot_capsule)
    -- Combat robots shouldn't go back to the turret that shot them, so we create an idle combat robot that doesn't
    -- follow its owner
    combat_robot_capsule = table.deepcopy(combat_robot_capsule)
    local combat_robot_prototype = get_combat_robot_prototype(utils.get_projectile(combat_robot_capsule))
    local idle_combat_robot = create_idle_combat_robot(combat_robot_prototype)
    update_projectile_combat_robot(utils.get_projectile(combat_robot_capsule), idle_combat_robot)
    local prototypes = ammo_factory.create_ammo_prototypes(combat_robot_capsule, data.raw["technology"]["automation"])
    table.insert(prototypes, idle_combat_robot)
    return prototypes
end

return combat_robot_ammo_factory
