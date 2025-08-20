local ammo_factory = require("prototypes.ammo.ammo_factory")

local capsule_ammo_factory = {}

--- @param capsule data.CapsulePrototype
function capsule_ammo_factory.create_capsule_ammo_prototypes(capsule)
    return ammo_factory.create_ammo_prototypes(capsule)
end

return capsule_ammo_factory
