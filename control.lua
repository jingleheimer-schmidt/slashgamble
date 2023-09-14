
---@param player LuaPlayer
---@param parameters string
local function gamble_number(player, parameters)
  local player_inventory = player.get_main_inventory()
  if not player_inventory or not player_inventory.valid then
    player.print({ "cmd.gamble-no-inventory" })
    return
  end
  local currency_name = settings.global["gamble-currency"].value --[[@as string]]
  local currency_localised_name = game.item_prototypes[currency_name] and game.item_prototypes[currency_name].localised_name or currency_name
  local currency_count = player_inventory.get_item_count(currency_name)
  if currency_count == 0 then
    player.print({ "cmd.gamble-no-currency", currency_name, currency_localised_name})
    return
  else
    local gamble_amount = tonumber(parameters)
    if not gamble_amount then
      player.print({ "cmd.gamble-invalid-input" })
      return
    end
    if gamble_amount < 1 then
      player.print({ "cmd.gamble-invalid-input" })
      return
    end
    if gamble_amount > currency_count then
      player.print({ "cmd.gamble-not-enough-currency", currency_name, currency_localised_name})
      return
    end
    local gamble_min = math.ceil(gamble_amount / 1000)
    local gamble_max = gamble_amount * 2
    local chance = math.random(1, 100)
    if chance > 75 then
      gamble_min = 1
      gamble_max = gamble_amount
    elseif chance > 50 then
      gamble_min = math.ceil(gamble_amount / 10)
      gamble_max = math.ceil(gamble_amount * 2)
    elseif chance > 25 then
      gamble_min = math.ceil(gamble_amount / 8)
      gamble_max = math.ceil(gamble_amount * 3)
    elseif chance > 5 then
      gamble_min = math.ceil(gamble_amount / 5)
      gamble_max = math.ceil(gamble_amount * 5)
    elseif chance > 1 then
      gamble_min = math.ceil(gamble_amount / 3)
      gamble_max = math.ceil(gamble_amount * 8)
    else
      gamble_min = math.ceil(gamble_amount / 2)
      gamble_max = math.ceil(gamble_amount * 10)
    end
    local winnings = math.random(gamble_min, gamble_max)
    player_inventory.remove({ name = currency_name, count = gamble_amount })
    if winnings > 250 then
      player_inventory.insert({ name = currency_name, count = math.floor(winnings - 250) })
      player.surface.spill_item_stack(player.position, { name = currency_name, count = 250 }, true)
    elseif winnings > 0 then
      player.surface.spill_item_stack(player.position, { name = currency_name, count = winnings }, true)
    end
    game.print({ "cmd.gamble-result", player.name, gamble_amount, winnings, currency_localised_name, winnings - gamble_amount })
  end
end

-- Define a function that converts a Color to a rich text color string
---@param color Color
local function format_color_for_rich_text(color)
  -- Check if the color is a valid table
  if type(color) == "table" then
      -- Extract the RGB components (assuming normalized [0, 1] range)
      local r = color.r or 0
      local g = color.g or 0
      local b = color.b or 0
      
      -- Convert the RGB components to [0, 255] range
      r = math.floor(r * 255)
      g = math.floor(g * 255)
      b = math.floor(b * 255)
      
      -- Create the rich text color string in the format #RRGGBB
      local richTextColor = string.format("#%02x%02x%02x", r, g, b)
      
      -- Return the rich text color string
      return richTextColor
  else
      -- If the input is not a valid table, return an empty string or handle the error as needed
      return ""
  end
end

---@param player LuaPlayer
---@param parameters string
local function gamble_all(player, parameters)
  local player_inventory = player.get_main_inventory()
  if not player_inventory or not player_inventory.valid then
    player.print({ "cmd.gamble-no-inventory" })
    return
  end
  local currency_name = settings.global["gamble-currency"].value --[[@as string]]
  local currency_count = player_inventory.get_item_count(currency_name)
  game.print({ "cmd.gamble-all", player.name, format_color_for_rich_text(player.chat_color) })
  gamble_number(player, tostring(currency_count))
end

---@param player LuaPlayer
---@param parameters string
local function gamble_half(player, parameters)
  local player_inventory = player.get_main_inventory()
  if not player_inventory or not player_inventory.valid then
    player.print({ "cmd.gamble-no-inventory" })
    return
  end
  local currency_name = settings.global["gamble-currency"].value --[[@as string]]
  local currency_count = player_inventory.get_item_count(currency_name)
  local half_currency_count = math.floor(currency_count / 2)
  game.print({ "cmd.gamble-half", player.name, format_color_for_rich_text(player.chat_color) })
  gamble_number(player, tostring(half_currency_count))
end

---@param player LuaPlayer
---@param parameters string
local function gamble_random(player, parameters)
  local player_inventory = player.get_main_inventory()
  if not player_inventory or not player_inventory.valid then
    player.print({ "cmd.gamble-no-inventory" })
    return
  end
  local currency_name = settings.global["gamble-currency"].value --[[@as string]]
  local currency_count = player_inventory.get_item_count(currency_name)
  local random_currency_count = math.random(1, currency_count)
  game.print({ "cmd.gamble-random", player.name, format_color_for_rich_text(player.chat_color) })
  gamble_number(player, tostring(random_currency_count))
end

local gamble_functions = {
  all = gamble_all,
  half = gamble_half,
  random = gamble_random,
  number = gamble_number,
}

---@param input string?
---@return "all"|"half"|"random"|"number"?
local function sanitize_input(input)
  if not input then return end
  input = input:lower()
  if input:find("all") then
    return "all"
  elseif input:find("half") then
    return "half"
  elseif input:find("random") then
    return "random"
  elseif tonumber(input) then
    return "number"
  end
end

---@param params CustomCommandData
local function gamble(params)
  if params.name ~= "gamble" then return end
  local player = game.get_player(params.player_index)
  if not player then return end
  local sanitized_input = sanitize_input(params.parameter)
  if not sanitized_input then
    player.print({ "cmd.gamble-invalid-input" })
    return
  else
    if not gamble_functions[sanitized_input] then
      player.print({ "cmd.gamble-invalid-input" })
      return
    else
      local gamble_function = gamble_functions[sanitized_input]
      local result = gamble_function and gamble_function(player, params.parameter)
    end
  end
end

local function add_commands()
  commands.add_command("gamble", { "cmd.gamble-help" }, gamble)
end

script.on_init(add_commands)
script.on_load(add_commands)
