local ui_handler = {}

-- Display weather info in the HUD
local function display_weather_info(blind)
    local weather_desc = blind.weather_effect and blind.weather_effect.description or "Unknown"
    G.HUD:add_text("Weather Effect: " .. weather_desc)
end

ui_handler.display_weather_info = display_weather_info

return ui_handler