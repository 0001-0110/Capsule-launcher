-- TODO Find a better name
local tools_utils = require("__toolbelt-22__.utils.utils")

-- cl stands for capsule launcher
local PREFIX = "22_cl"

local utils = {}

--- Remove a part of the string
function utils.string_remove(string, substitution)
    return string:gsub(substitution, "")
end

--- Add the mod prefix to the given string
function utils.prefix(name)
    return string.format("%s_%s", PREFIX, name)
end

--- Recursively merges override into base.
--- If override[key] is a function, calls it with base[key] and data and assigns result.
--- If both base[key] and override[key] are tables, merges recursively.
--- Otherwise, override[key] replaces base[key].
--- @param base table
--- @param override table
--- @param data any
--- @return table
function utils.override_table(base, override, data)
    for key, value in pairs(base) do
        local override_value = override[key]

        if override_value then
            if type(override_value) == "function" then
                base[key] = override_value(value, data)
                -- Only merge recursively tables, not arrays
            elseif type(override_value) == "table" and not tools_utils.is_array(override_value) then
                base[key] = utils.override_table(table.deepcopy(base[key]), override_value, data)
            else
                base[key] = override_value
            end
        end
    end
    return base
end

function utils.create_prototype(prototype_data)
    local prototype = table.deepcopy(data.raw[prototype_data.type][prototype_data.based_on])
    return utils.override_table(prototype, prototype_data)
end

--- @param capsule data.CapsulePrototype
function utils.get_projectile(capsule)
    local projectile_name = capsule.capsule_action.attack_parameters.ammo_type.action[1].action_delivery.projectile
    return data.raw["projectile"][projectile_name]
end

--- @param entity_name string
function utils.is_combat_robot(entity_name)
    return data.raw["combat-robot"][entity_name] ~= nil
end

function utils.is_combat_robot_effect(effect)
    return effect.entity_name and utils.is_combat_robot(effect.entity_name)
end

return utils
