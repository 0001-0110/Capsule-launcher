local utils = require("utils.utils")

data:extend({
    {
        -- Setting to decide if the basic rocket recipe should be changed to use the new empty rocket item or not
        type = "bool-setting",
        name = utils.prefix("change-rocket-recipe-setting"),
        default_value = true,
        setting_type = "startup",
    }
})
