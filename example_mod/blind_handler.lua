local weather_effects = require("weather_effects")

local blind_handler = {}

function blind_handler.assign_weather(blind)
    local weather_keys = {}
    for key, _ in pairs(weather_effects) do
        table.insert(weather_keys, key)
    end
    local chosen_weather = weather_keys[math.random(#weather_keys)]
    blind.weather_effect = weather_effects[chosen_weather]
end

function blind_handler.reroll_weather(blind)
    local weather_keys = {}
    for key, _ in pairs(weather_effects) do
        if blind.weather_effect.id ~= key then
            table.insert(weather_keys, key)
        end
    end
    local new_weather = weather_keys[math.random(#weather_keys)]
    blind.weather_effect = weather_effects[new_weather]
end

function blind_handler.initialize_blinds()
    for _, blind in ipairs(G.GAME.blinds) do
        blind_handler.assign_weather(blind)
    end
end

return blind_handler
