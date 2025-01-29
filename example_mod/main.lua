local mod_id = "weather_mod"

-- Logger
local logging = require("logging")
local logger = logging.getLogger(mod_id)

-- APIs & Functional Modules
local weather_effects = require("weather_effects")
local blind_handler = require("blind_handler")
local ui_handler = require("ui_handler")
local balamod = require("balamod")

-- Mod Configuration
local mod_config = {}

-- Called when the mod is enabled
local function on_enable()
    logger:info("Weather Mod enabled")
    blind_handler.initialize_blinds()
end

-- Called when the mod is disabled
local function on_disable()
    logger:info("Weather Mod disabled")
end

-- Called when the game loads (useful for loading settings or injected code)
local function on_game_load(args)
    mod_config = balamod.mods[mod_id].load_config() or {}
    logger:info("Weather Mod settings loaded")
end

-- Called when the game is closing (save config)
local function on_game_quit()
    if not mod_config then
        mod_config = { enable_forecast = false }  -- Default settings
    end
    balamod.mods[mod_id].save_config(mod_config)
end

-- Developer Console Command (Weather Reroll)
local function on_key_pressed(key)
    if key == "r" then  -- Example: Press 'R' to reroll weather
        if G.GAME.current_blind then
            blind_handler.reroll_weather(G.GAME.current_blind)
            logger:info("Weather effect rerolled: " .. G.GAME.current_blind.weather_effect.description)
        end
    end
end

-- UI Toggle for Weather Forecast
local function on_mouse_pressed(button, x, y, touch)
    if button == 2 then  -- Right-click to show forecast
        if G.GAME.current_blind then
            ui_handler.display_weather_info(G.GAME.current_blind)
        end
    end
end

-- Debugging: Log any errors
local function on_error(message)
    logger:error("Weather Mod Error: " .. message)
end

return {
    on_enable = on_enable,
    on_disable = on_disable,
    on_game_load = on_game_load,
    on_game_quit = on_game_quit,
    on_key_pressed = on_key_pressed,
    on_mouse_pressed = on_mouse_pressed,
    on_error = on_error
}
