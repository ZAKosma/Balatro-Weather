local weather_effects = require("weather_effects")

local blind_handler = {}

function blind_handler.assign_weather(blind)
    if type(weather_effects) ~= "table" then
        logger:error("weather_effects is not a table! Got: " .. type(weather_effects))
        return
    end

    local weather_keys = {}
    for key, _ in pairs(weather_effects) do
        table.insert(weather_keys, key)
    end

    if #weather_keys == 0 then
        logger:error("No valid weather effects found!")
        return
    end

    local chosen_weather = weather_keys[math.random(#weather_keys)]
    blind.weather_effect = weather_effects[chosen_weather]
end

function blind_handler.reroll_weather(blind)
    if type(weather_effects) ~= "table" then
        logger:error("weather_effects is not a table! Got: " .. type(weather_effects))
        return
    end

    local weather_keys = {}
    for key, _ in pairs(weather_effects) do
        if blind.weather_effect and blind.weather_effect.id ~= key then
            table.insert(weather_keys, key)
        end
    end

    if #weather_keys == 0 then
        logger:error("No alternate weather effects available!")
        return
    end

    local new_weather = weather_keys[math.random(#weather_keys)]
    if weather_effects[new_weather] then
        blind.weather_effect = weather_effects[new_weather]
        logger:info("Rerolled weather to: " .. new_weather)
    else
        logger:error("Failed to assign weather effect, new_weather: " .. tostring(new_weather))
    end
end

function blind_handler.initialize_blinds()
    if type(G.GAME.blinds) ~= "table" then
        logger:error("G.GAME.blinds is not a table!")
        return
    end

    for _, blind in ipairs(G.GAME.blinds) do
        blind_handler.assign_weather(blind)
    end
end

return blind_handler
