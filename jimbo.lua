--- STEAMODDED HEADER
--- MOD_NAME: Card Value Displays
--- MOD_ID: CardValueDisplay
--- MOD_AUTHOR: [elial1]
--- MOD_DESCRIPTION: Displays extra values of a card
--- PRIORITY: 999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999

G.localization.descriptions.Other['card_extra_mult'] = {
    text = {
        "{C:mult}+#1#{} extra mult"
    }
}
G.localization.descriptions.Other['card_extra_h_mult'] = {
    text = {
        "{C:mult}+#1#{} extra mult", 'when held in hand'
    }
}
G.localization.descriptions.Other['card_extra_x_mult'] = {
    text = {
        "{X:mult,C:white}X#1#{} extra mult"
    }
}
G.localization.descriptions.Other['card_extra_h_x_mult'] = {
    text = {
        "{X:mult,C:white}X#1#{} extra mult", 'when held in hand'
    }
}
G.localization.descriptions.Other['card_extra_h_dollars'] = {
    text = {
        "{C:money}+#1#{} extra dollars",'when held in hand'
    }
}
G.localization.descriptions.Other['card_extra_p_dollars'] = {
    text = {
        "{C:money}+#1#{} extra dollars", 'when played'
    }
}
local oldfunc = generate_card_ui
    function generate_card_ui(_c, full_UI_table, specific_vars, card_type, badges, hide_desc, main_start, main_end,card)
        full_UI_table = oldfunc(_c, full_UI_table, specific_vars, card_type, badges, hide_desc, main_start, main_end,card)
        if card and card.ability and card.ability.set and (card.ability.set == 'Enhanced' or card.ability.set == 'Default') then
            local desc_nodes = full_UI_table.main
            if card.ability.mult ~= 0 and not (_c and _c.effect == 'Mult Card') and not (_c and _c.effect == 'Lucky Card') then
                localize{type = 'other', key = 'card_extra_mult', nodes = desc_nodes, vars = {card.ability.mult}}
            end
            if card.ability.h_mult ~= 0 then
                localize{type = 'other', key = 'card_extra_h_mult', nodes = desc_nodes, vars = {card.ability.h_mult}}
            end
            if card.ability.x_mult ~= 1 and not (_c and _c.effect == 'Glass Card') then
                localize{type = 'other', key = 'card_extra_x_mult', nodes = desc_nodes, vars = {card.ability.x_mult}}
            end
            if card.ability.h_x_mult ~= 0 and not (_c and _c.effect == 'Steel Card') then
                localize{type = 'other', key = 'card_extra_h_x_mult', nodes = desc_nodes, vars = {card.ability.h_x_mult}}
            end
            if card.ability.h_dollars ~= 0 and not (_c and _c.effect == 'Gold Card') then
                localize{type = 'other', key = 'card_extra_h_dollars', nodes = desc_nodes, vars = {card.ability.h_dollars}}
            end
            if card.ability.p_dollars ~= 0 and not (_c and _c.effect == 'Lucky Card') then
                localize{type = 'other', key = 'card_extra_p_dollars', nodes = desc_nodes, vars = {card.ability.p_dollars}}
            end
        end
        return full_UI_table
end

local valued = SMODS.Back{
    key = "valued",
    name = "Valued Deck",
    loc_txt = {
        name = "Valued Deck",
        text = {
        "All cards in deck",
        'are {C:legendary}randomized'
        },

    },
    config = {
        extra = {
            
        }
    },
    apply = function(back) 
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 1,
            blocking = false,
            blockable = false,
            func = (function()
                for i = 1, #G.playing_cards do
                    local stats = {
                        'mult', --played mult
                        'h_mult', --held mult
                        'h_x_mult', --held xmult
                        'h_dollars', --held dollar gain
                        'p_dollars', --played dollar gain
                        'x_mult', --played xmult
                    }
                    for ii = 1, 3 do
                        local index = pseudorandom('chaos',1,#stats)
                        local min = -100
                        local max = 300
                        if stats[index] == 'x_mult' or stats[index] == 'h_x_mult' then
                            min = 50
                            max = 200
                        end
                        G.playing_cards[i].ability[stats[index]] = G.playing_cards[i].ability[stats[index]] == 0 and 1 or G.playing_cards[i].ability[stats[index]]
                        local stat = pseudorandom('chaos_stat', min, max)/100
                        G.playing_cards[i].ability[stats[index]] = G.playing_cards[i].ability[stats[index]] * stat
                        table.remove(stats,index)
                    end
                end
                return true
            end)
        }))
    end,
    loc_vars = function(self)
        return { vars = {} }
    end,
}


----------------------------------------------
------------MOD CODE END----------------------
