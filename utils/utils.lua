-- cl stands for capsule launcher
local PREFIX = "22_cl"

local utils = {}

-- TODO Need a better name
function utils.first(list, predicate)
    if list == nil then
        error()
    end

    if not utils.is_array(list) and predicate(list) then
        return list
    end

    for _, value in ipairs(list) do
        if predicate(value) then
            return value
        end
    end

    error()
end

function utils.any(list, predicate)
    if list == nil then
        return false
    end

    if not utils.is_array(list) then
        return predicate(list)
    end

    for _, value in ipairs(list) do
        if predicate(value) then
            return true
        end
    end

    return false
end

--- Take the `count` first element of the given table
function utils.take(list, count)
    local result = {}
    for i = 1, math.min(count, #list) do
        table.insert(result, list[i])
    end
    return result
end

--- Remove a part of the string
function utils.string_remove(string, substitution)
    return string:gsub(substitution, "")
end

--- Add the mod prefix to the given string
function utils.prefix(name)
    return string.format("%s_%s", PREFIX, name)
end

--- Checks if a table is used as an array. That is: the keys start with one and are sequential numbers
--- @param table table
--- @return boolean isArray true if the table is an array, false if it is not a table or a table that is not an array
--- Returns true for an empty table
function utils.is_array(table)
    if type(table) ~= "table" then
        return false
    end

    -- Check if all the table keys are numerical and count their number
    local count = 0
    for key, _ in pairs(table) do
        if type(key) ~= "number" then
            return false
        else
            count = count + 1
        end
    end

    -- All keys are numerical. now let's see if they are sequential and start with 1
    for i = 1, count do
        -- The value might be "nil", in that case "not table[i]" isn't enough, that's why we check the type
        if not table[i] and type(table[i]) ~= "nil" then
            return false
        end
    end
    return true
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
            elseif type(override_value) == "table" and not utils.is_array(override_value) then
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
