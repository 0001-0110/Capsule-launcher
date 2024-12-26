local BASED_ON = "rocket-turret"

local module = {}

local hive_launcher_entity = table.deepcopy(data.raw["ammo-turret"][BASED_ON])
hive_launcher_entity.name = "22_hl_hive-launcher-entity"
hive_launcher_entity.attack_parameters.ammo_category = "22_hl_hive-capsule"

local hive_launcher_item = table.deepcopy(data.raw["item"][BASED_ON])
hive_launcher_item.name = "22_hl_hive-launcher-item"
hive_launcher_item.place_result = hive_launcher_entity.name

hive_launcher_entity.minable.result = hive_launcher_item.name

local hive_launcher_recipe = table.deepcopy(data.raw["recipe"][BASED_ON])
hive_launcher_recipe.name = "22_hl_hive-launcher-recipe"
hive_launcher_recipe.enabled = true
hive_launcher_recipe.results =
{
    {
        type = "item",
        name = hive_launcher_item.name,
        amount = 1,
    }
}

module.prototypes = { hive_launcher_entity, hive_launcher_item, hive_launcher_recipe, }
return module
