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

local function dump(o)
   if type(o) == 'table' then
      local s = '{ '
      for k,v in pairs(o) do
         if type(k) ~= 'number' then k = '"'..k..'"' end
         s = s .. '['..k..'] = ' .. dump(v) .. ','
      end
      return s .. '} '
   else
      return tostring(o)
   end
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
    for key, override_value in pairs(override) do
        if type(override_value) == "function" then
            log("Overriding " .. key .. " from " .. dump(base[key]) .. " to " .. dump(override_value(base[key], data)))
            base[key] = override_value(base[key], data)
        elseif type(override_value) == "table" and not tools_utils.is_array(override_value) then
            -- Only merge recursively tables, not arrays
            base[key] = utils.override_table(table.deepcopy(base[key]), override_value, data)
        else
            log("Overriding " .. key .. " from " .. dump(base[key]) .. " to " .. dump(override_value))
            base[key] = override_value
        end
    end
    return base
end

function utils.create_prototype(prototype_data)
    local prototype = table.deepcopy(data.raw[prototype_data.type][prototype_data.based_on])
    local result = utils.override_table(prototype, prototype_data)
    log(dump(result))
    return result
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
