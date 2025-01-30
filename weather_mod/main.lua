local mod_id = "weather_mod"

-- Logger
local logging = require("logging")
local logger = logging.getLogger(mod_id)

-- APIs & Functional Modules
local function safe_require(module_name)
    local success, result = pcall(require, module_name)
    if not success then
        logger:error("Failed to load module: " .. module_name .. " | Error: " .. result)
        return nil
    end
    return result
end

local weather_effects = safe_require("weather_effects") or {}
local blind_handler = safe_require("blind_handler") or {}
local ui_handler = safe_require("ui_handler") or {}
local balamod = safe_require("balamod") or {}

-- Debugging: Ensure Modules Are Loaded Correctly
logger:info("weather_effects type: " .. type(weather_effects))
logger:info("blind_handler type: " .. type(blind_handler))
logger:info("ui_handler type: " .. type(ui_handler))
logger:info("balamod type: " .. type(balamod))

-- Mod Configuration
local mod_config = {}

-- Called when the mod is enabled
local function on_enable()
    logger:info("Weather Mod enabled")

    -- Initialize custom blinds
    if type(blind_handler.initialize_blinds) == "function" then
        local success, err = pcall(blind_handler.initialize_blinds)
        if not success then
            logger:error("Failed to initialize blinds: " .. tostring(err))
        end
    else
        logger:error("blind_handler.initialize_blinds is missing or not a function")
    end

    -- Override blind selection to force weather effects
    if type(blind_handler.override_blind_selection) == "function" then
        local success, err = pcall(blind_handler.override_blind_selection)
        if not success then
            logger:error("Failed to override blind selection: " .. tostring(err))
        end
    else
        logger:error("blind_handler.override_blind_selection is missing or not a function")
    end
end

-- Called when the mod is disabled
local function on_disable()
    logger:info("Weather Mod disabled")
end

-- Called when the game loads (useful for loading settings or injected code)
local function on_game_load(args)
    logger:info("Game load started")

    -- Load mod configuration
    if balamod and balamod.mods and balamod.mods[mod_id] and type(balamod.mods[mod_id].load_config) == "function" then
        mod_config = balamod.mods[mod_id].load_config() or {}
    else
        logger:error("Failed to access balamod.mods[mod_id].load_config")
        mod_config = {}
    end

    -- Debugging: Ensure mod_config is a table
    if type(mod_config) ~= "table" then
        logger:error("mod_config is not a table! Received: " .. type(mod_config))
        mod_config = {}  -- Reset to empty table if corrupted
    end

    logger:info("Weather Mod settings loaded")
end

-- Called when the game is closing (save config)
local function on_game_quit()
    if not mod_config then
        mod_config = { enable_forecast = false }  -- Default settings
    end
    if balamod and balamod.mods and balamod.mods[mod_id] and type(balamod.mods[mod_id].save_config) == "function" then
        balamod.mods[mod_id].save_config(mod_config)
    else
        logger:error("Failed to access balamod.mods[mod_id].save_config")
    end
end

-- Developer Console Command (Weather Reroll)
local function on_key_pressed(key)
    if key == "r" then  -- Example: Press 'R' to reroll weather
        logger:info("Key pressed: R")

        if G and G.GAME and G.GAME.current_blind then
            logger:info("Current blind exists, attempting to reroll weather...")

            local success, err = pcall(blind_handler.reroll_weather, G.GAME.current_blind)
            if not success then
                logger:error("Error in reroll_weather: " .. tostring(err))
            end

            -- Check that weather_effect is valid before logging
            local effect_desc = "Unknown"
            if G.GAME.current_blind and type(G.GAME.current_blind.weather_effect) == "table" then
                effect_desc = G.GAME.current_blind.weather_effect.description or "Unknown"
            end

            logger:info("Weather effect rerolled: " .. effect_desc)
        else
            logger:warn("No current blind found or G.GAME is missing!")
        end
    end
end

-- UI Toggle for Weather Forecast
local function on_mouse_pressed(button, x, y, touch)
    if button == 2 then  -- Right-click to show forecast
        logger:info("Right-click detected, checking for weather info...")

        if G and G.GAME and G.GAME.current_blind then
            local success, err = pcall(ui_handler.display_weather_info, G.GAME.current_blind)
            if not success then
                logger:error("Error in display_weather_info: " .. tostring(err))
            end
        else
            logger:warn("No current blind to display weather for!")
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