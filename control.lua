local function percent(value, min, max)
    if value < min then
        return 0
    elseif value > max then
        return 100
    else
        return ((value - min) / (max - min)) * 100
    end
end

local function format_number(number)
    local abbreviations = {
        "",
        "K", -- Thousand
        "M", -- Million
        "B", -- Billion
        "T", -- Trillion
        "Qa", -- Quadrillion
        "Qi", -- Quintillion
        "Sx", -- Sextillion
        "Sp", -- Septillion
        "Oc", -- Octillion
        "No", -- Nonillion
        "Dc", -- Decillion
        "Ud", -- Undecillion
        "Dd", -- Duodecillion
        "Td", -- Tredecillion
        "Qad", -- Quattuordecillion
        "Qid", -- Quindecillion
        "Sxd", -- Sexdecillion
        "Spd", -- Septendecillion
        "Ocd", -- Octodecillion
        "Nod", -- Novemdecillion
        "Vg", -- Vigintillion
        "Uvg", -- Unvigintillion
    }

    local abs_number = math.abs(number)
    local num_abbreviation = 1

    while abs_number >= 1000 and num_abbreviation < #abbreviations do
        abs_number = abs_number / 1000
        num_abbreviation = num_abbreviation + 1
    end

    local formatted_number = abs_number >= 1 and string.format("%.2f", abs_number) or string.format("%.0f", abs_number)
    formatted_number = formatted_number:gsub("^0+(%d+%.%d+)$", "%1") -- Remove leading zeros
    formatted_number = formatted_number:gsub("%.(0+)", "")         -- Remove trailing .00s

    return formatted_number .. abbreviations[num_abbreviation]
end

---@param ticks number
---@return LocalisedString
local function format_time(ticks)
    local modifier = game.speed
    ticks = ticks / modifier

    local seconds = math.floor(ticks / 60)
    local minutes = math.floor(seconds / 60)
    local hours = math.floor(minutes / 60)
    local days = math.floor(hours / 24)

    ticks = math.floor(ticks % 60)
    seconds = math.floor(seconds % 60)
    minutes = math.floor(minutes % 60)
    hours = math.floor(hours % 24)

    local days_string = { "time.days", days }
    local hours_string = { "time.hours", hours }
    local minutes_string = { "time.minutes", minutes }
    local seconds_string = { "time.seconds", seconds, math.floor(percent(ticks, 0, 60)) }

    local time_string = "" --[[@type LocalisedString]]
    if days > 0 then
        time_string = { "", days_string, ", ", hours_string, ", ", minutes_string, ", ", seconds_string }
    elseif hours > 0 then
        time_string = { "", hours_string, ", ", minutes_string, ", ", seconds_string }
    elseif minutes > 0 then
        time_string = { "", minutes_string, ", ", seconds_string }
    else
        time_string = seconds_string
    end

    return time_string
end

local function format_color_for_rich_text(color)
    if type(color) == "table" then
        local r = math.floor((color.r or 0) * 255)
        local g = math.floor((color.g or 0) * 255)
        local b = math.floor((color.b or 0) * 255)
        return string.format("#%02x%02x%02x", r, g, b)
    else
        return ""
    end
end

---@param player LuaPlayer
---@param parameter string?
local function gamble(player, parameter)
    if not parameter or parameter == "" or parameter == "help" then
        player.print({ "cmd.gamble-help" })
        return
    end

    local chat_color = format_color_for_rich_text(player.chat_color)
    local player_name = player.name
    local player_index = player.index
    local game_tick = game.tick

    global.timeout = global.timeout or {}
    global.timeout[player_index] = global.timeout[player_index] or 0
    local last_gamble_tick = global.timeout[player_index]
    local cooldown = settings.global["gamble-timeout"].value --[[@as int]]
    local timeout_until_tick = last_gamble_tick + (cooldown * 60)

    if game.tick < timeout_until_tick then
        player.print({ "cmd.gamble-amount", player.name, chat_color, parameter })
        player.print({ "cmd.gamble-timeout", format_time(timeout_until_tick - game_tick) })
        return
    end

    local inventory = player.get_main_inventory()
    if not inventory or not inventory.valid then
        player.print({ "cmd.gamble-amount", player_name, chat_color, parameter })
        player.print({ "cmd.gamble-no-inventory" })
        return
    end

    local currency_name = settings.global["gamble-currency"].value --[[@as string]]
    local currency_prototype = game.item_prototypes[currency_name]
    if not currency_prototype then
        player.print({ "cmd.gamble-amount", player_name, chat_color, parameter })
        player.print({ "cmd.gamble-invalid-currency", currency_name })
        return
    end
    local currency_count = inventory.get_item_count(currency_name)

    if currency_count == 0 then
        player.print({ "cmd.gamble-amount", player_name, chat_color, parameter })
        player.print({ "cmd.gamble-no-currency", currency_name })
        return
    end

    local gamble_amount
    if parameter:find("all") then
        gamble_amount = currency_count
    elseif parameter:find("half") then
        gamble_amount = math.floor(currency_count / 2)
    elseif parameter:find("random") then
        gamble_amount = math.random(1, currency_count)
    else
        gamble_amount = tonumber(parameter) or tonumber(parameter:match("%d+"))
    end

    if not gamble_amount or gamble_amount < 1 then
        player.print({ "cmd.gamble-amount", player_name, chat_color, parameter })
        player.print({ "cmd.gamble-invalid-input" })
        return
    end

    if gamble_amount > currency_count then
        player.print({ "cmd.gamble-amount", player_name, chat_color, parameter })
        player.print({ "cmd.gamble-not-enough-currency", currency_name })
        return
    end

    local chance = math.random(0, 100)

    gamble_amount = math.floor(gamble_amount)

    local winnings = 0

    if chance < 10 then
        winnings = 0
    elseif chance < 20 then
        winnings = gamble_amount / 4
    elseif chance < 30 then
        winnings = gamble_amount / 3
    elseif chance < 40 then
        winnings = gamble_amount / 2
    elseif chance < 50 then
        winnings = gamble_amount * 1
    elseif chance < 60 then
        winnings = gamble_amount * 1.5
    elseif chance < 70 then
        winnings = gamble_amount * 2
    elseif chance < 80 then
        winnings = gamble_amount * 2.5
    elseif chance < 90 then
        winnings = gamble_amount * 3
    elseif chance < 95 then
        winnings = gamble_amount * 4
    elseif chance < 99 then
        winnings = gamble_amount * 5
    else
        winnings = gamble_amount * 10
    end

    winnings = math.abs(math.floor(winnings))

    inventory.remove({ name = currency_name, count = gamble_amount })

    local spill_amount = 250
    if winnings > spill_amount then
        local insert_amount = math.floor(winnings - spill_amount)
        local insert_stack = { name = currency_name, count = insert_amount }
        local inserted = inventory.insert(insert_stack)
        spill_amount = spill_amount + (insert_amount - inserted)
        local spill_stack = { name = currency_name, count = spill_amount }
        player.surface.spill_item_stack(player.position, spill_stack, true)
    elseif winnings > 0 then
        local spill_stack = { name = currency_name, count = winnings }
        player.surface.spill_item_stack(player.position, spill_stack, true)
    end

    game.print({ "cmd.gamble-amount", player.name, chat_color, parameter })

    local net_gain = winnings - gamble_amount
    local net_color = net_gain >= 0 and "green" or "red"
    local net_gain_string = net_gain >= 0 and "+" .. format_number(net_gain) or "-" .. format_number(net_gain)

    game.print({ "cmd.gamble-result", player.name, chance, format_number(gamble_amount), currency_name, net_color,
        net_gain_string })

    global.timeout[player_index] = game_tick
end

local function add_gamble_command()
    commands.add_command("gamble", { "cmd.gamble-help" }, function(params)
        local player = game.get_player(params.player_index)
        if player then
            gamble(player, params.parameter)
        end
    end)
end

script.on_init(add_gamble_command)
script.on_load(add_gamble_command)
