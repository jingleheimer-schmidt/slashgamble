
local currency_setting = {
    type = "string-setting",
    name = "gamble-currency",
    setting_type = "runtime-global",
    default_value = "coin",
}
data:extend{currency_setting}

local timeout_setting = {
    type = "int-setting",
    name = "gamble-timeout",
    setting_type = "runtime-global",
    default_value = 15,
    minimum_value = 0,
}
data:extend{timeout_setting}
