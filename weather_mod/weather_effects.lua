local weather_effects = {
    rainstorm = {
        id = "rainstorm",
        description = "Reduce chip rewards by 10%, but increase multiplier.",
        apply_effect = function()
            if G.GAME then
                G.GAME.chip_reward_multiplier = G.GAME.chip_reward_multiplier * 0.9
                G.GAME.multiplier_bonus = (G.GAME.multiplier_bonus or 0) + 0.2
            else
                logger:error("G.GAME is nil!")
            end
        end,
        remove_effect = function()
            if G.GAME then
                G.GAME.chip_reward_multiplier = G.GAME.chip_reward_multiplier / 0.9
                G.GAME.multiplier_bonus = (G.GAME.multiplier_bonus or 0) - 0.2
            else
                logger:error("G.GAME is nil!")
            end
        end,
    },
    thunderstorm = {
        id = "thunderstorm",
        description = "One random joker gets disabled for the round.",
        apply_effect = function()
            if G.jokers and G.jokers.cards and #G.jokers.cards > 0 then
                local random_joker = G.jokers.cards[math.random(#G.jokers.cards)]
                random_joker.disabled = true
                random_joker.weather_disabled = true
            else
                logger:error("No jokers found in G.jokers.cards!")
            end
        end,
        remove_effect = function()
            if G.jokers and G.jokers.cards then
                for _, joker in ipairs(G.jokers.cards) do
                    if joker.weather_disabled then
                        joker.disabled = false
                        joker.weather_disabled = nil
                    end
                end
            else
                logger:error("No jokers found to restore!")
            end
        end,
    },
}

return weather_effects