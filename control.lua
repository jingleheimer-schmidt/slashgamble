
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
    "K",   -- Thousand
    "M",   -- Million
    "B",   -- Billion
    "T",   -- Trillion
    "Qa",  -- Quadrillion
    "Qi",  -- Quintillion
    "Sx",  -- Sextillion
    "Sp",  -- Septillion
    "Oc",  -- Octillion
    "No",  -- Nonillion
    "Dc",  -- Decillion
    "Ud",  -- Undecillion
    "Dd",  -- Duodecillion
    "Td",  -- Tredecillion
    "Qad", -- Quattuordecillion
    "Qid", -- Quindecillion
    "Sxd", -- Sexdecillion
    "Spd", -- Septendecillion
    "Ocd", -- Octodecillion
    "Nod", -- Novemdecillion
    "Vg",  -- Vigintillion
    "Uvg", -- Unvigintillion
  }

  local abs_number = math.abs(number)
  local num_abbreviation = 1

  while abs_number >= 1000 and num_abbreviation < #abbreviations do
    abs_number = abs_number / 1000
    num_abbreviation = num_abbreviation + 1
  end

  local formatted_number = abs_number >= 1 and string.format("%.2f", abs_number) or string.format("%.0f", abs_number)
  formatted_number = formatted_number:gsub("^0+(%d+%.%d+)$", "%1")  -- Remove leading zeros
  formatted_number = formatted_number:gsub("%.(0+)", "")            -- Remove trailing .00s

  return formatted_number .. abbreviations[num_abbreviation]
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

  local inventory = player.get_main_inventory()
  if not inventory or not inventory.valid then
    player.print({ "cmd.gamble-amount", player.name, format_color_for_rich_text(player.chat_color), parameter })
    player.print({ "cmd.gamble-no-inventory" })
    return
  end

  local currency_name = settings.global["gamble-currency"].value
  local currency_count = inventory.get_item_count(currency_name)

  if currency_count == 0 then
    player.print({ "cmd.gamble-amount", player.name, format_color_for_rich_text(player.chat_color), parameter })
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
    gamble_amount = tonumber(parameter)
  end

  if not gamble_amount or gamble_amount < 1 then
    player.print({ "cmd.gamble-amount", player.name, format_color_for_rich_text(player.chat_color), parameter })
    player.print({ "cmd.gamble-invalid-input" })
    return
  end

  if gamble_amount > currency_count then
    player.print({ "cmd.gamble-amount", player.name, format_color_for_rich_text(player.chat_color), parameter })
    player.print({ "cmd.gamble-not-enough-currency", currency_name })
    return
  end

  local chance = math.random(1, 100)
  local gamble_min, gamble_max

  gamble_amount = math.floor(gamble_amount)

  if chance > 75 then
    gamble_min, gamble_max = 1, gamble_amount
  elseif chance > 50 then
    gamble_min, gamble_max = math.ceil(gamble_amount / 10), math.ceil(gamble_amount * 2)
  elseif chance > 25 then
    gamble_min, gamble_max = math.ceil(gamble_amount / 8), math.ceil(gamble_amount * 3)
  elseif chance > 5 then
    gamble_min, gamble_max = math.ceil(gamble_amount / 5), math.ceil(gamble_amount * 5)
  elseif chance > 1 then
    gamble_min, gamble_max = math.ceil(gamble_amount / 3), math.ceil(gamble_amount * 8)
  else
    gamble_min, gamble_max = math.ceil(gamble_amount / 2), math.ceil(gamble_amount * 10)
  end

  gamble_min = math.floor(gamble_min)
  gamble_max = math.floor(gamble_max)

  local winnings = math.random(gamble_min, gamble_max)
  inventory.remove({ name = currency_name, count = gamble_amount })

  if winnings > 250 then
    inventory.insert({ name = currency_name, count = math.floor(winnings - 250) })
    player.surface.spill_item_stack(player.position, { name = currency_name, count = 250 }, true)
  elseif winnings > 0 then
    player.surface.spill_item_stack(player.position, { name = currency_name, count = winnings }, true)
  end

  game.print({ "cmd.gamble-amount", player.name, format_color_for_rich_text(player.chat_color), parameter })
  local roll_1 = chance
  local roll_2 = math.ceil(percent(winnings, gamble_min, gamble_max))

  game.print({ "cmd.gamble-result", player.name, gamble_amount, winnings, currency_name, winnings - gamble_amount, roll_1, roll_2 })
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
