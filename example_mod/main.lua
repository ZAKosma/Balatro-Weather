local logging = require("logging")
local logger = logging.getLogger("weather_mod")

-- Import functional modules
local weather_effects = require("weather_effects")
local blind_handler = require("blind_handler")
local ui_handler = require("ui_handler")

-- Called when the mod is enabled
local function on_enable()
    logger:info("Weather Mod enabled")
    blind_handler.initialize_blinds()
end

-- Called when the mod is disabled (Optional)
local function on_disable()
    logger:info("Weather Mod disabled")
end

return {
    on_enable = on_enable,
    on_disable = on_disable
}
