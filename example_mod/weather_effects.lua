local weather_effects = {
    rainstorm = {
        id = "rainstorm",
        description = "Reduce chip rewards by 10%, but increase multiplier.",
        apply_effect = function()
            G.GAME.chip_reward_multiplier = G.GAME.chip_reward_multiplier * 0.9
            G.GAME.multiplier_bonus = (G.GAME.multiplier_bonus or 0) + 0.2
        end,
        remove_effect = function()
            G.GAME.chip_reward_multiplier = G.GAME.chip_reward_multiplier / 0.9
            G.GAME.multiplier_bonus = (G.GAME.multiplier_bonus or 0) - 0.2
        end,
    },
    thunderstorm = {
        id = "thunderstorm",
        description = "One random joker gets disabled for the round.",
        apply_effect = function()
            if #G.jokers.cards > 0 then
                local random_joker = G.jokers.cards[math.random(#G.jokers.cards)]
                random_joker.disabled = true
                random_joker.weather_disabled = true
            end
        end,
        remove_effect = function()
            for _, joker in ipairs(G.jokers.cards) do
                if joker.weather_disabled then
                    joker.disabled = false
                    joker.weather_disabled = nil
                end
            end
        end,
    },
    -- Additional weather effects...
}

return weather_effects
