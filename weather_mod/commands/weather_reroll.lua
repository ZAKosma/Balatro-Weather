local blind_handler = require("blind_handler")

return {
    on_load = function(console)
        if G.GAME.current_blind then
            blind_handler.reroll_weather(G.GAME.current_blind)
            console:log("Weather effect rerolled to: " .. G.GAME.current_blind.weather_effect.description)
        else
            console:log("No active blind to reroll weather for.")
        end
    end,
    on_complete = function(console, currentArg, previousArgs)
        return nil
    end
}
