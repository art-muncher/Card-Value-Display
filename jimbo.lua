--- STEAMODDED HEADER
--- MOD_NAME: Card Value Displays
--- MOD_ID: CardValueDisplay
--- MOD_AUTHOR: [elial1]
--- MOD_DESCRIPTION: Displays extra values of a card
--- PRIORITY: 0

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
        "{C:money}+#1#{} extra dollars",'when held in hand','at end of round'
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
    if card and card.ability then
        local desc_nodes = full_UI_table.main
        if card.ability.bonus_mult ~= 0 then
            localize{type = 'other', key = 'card_extra_mult', nodes = desc_nodes, vars = {card.ability.bonus_mult}}
        end
        if card.ability.bonus_h_mult ~= 0 then
            localize{type = 'other', key = 'card_extra_h_mult', nodes = desc_nodes, vars = {card.ability.bonus_h_mult}}
        end
        if card.ability.bonus_x_mult ~= 1 then
            localize{type = 'other', key = 'card_extra_x_mult', nodes = desc_nodes, vars = {card.ability.bonus_x_mult}}
        end
        if card.ability.bonus_h_x_mult ~= 1 then
            localize{type = 'other', key = 'card_extra_h_x_mult', nodes = desc_nodes, vars = {card.ability.bonus_h_x_mult}}
        end
        if card.ability.bonus_h_dollars ~= 0 then
            localize{type = 'other', key = 'card_extra_h_dollars', nodes = desc_nodes, vars = {card.ability.bonus_h_dollars}}
        end
        if card.ability.bonus_p_dollars ~= 0 then
            localize{type = 'other', key = 'card_extra_p_dollars', nodes = desc_nodes, vars = {card.ability.bonus_p_dollars}}
        end
    end
    return full_UI_table
end

local oldfunc = Card.set_ability
function Card:set_ability(center, initial, delay_sprites)
    local bonus_abilities = {
        bonus_mult = 0,
        bonus_h_mult = 0,
        bonus_x_mult = 1,
        bonus_h_x_mult = 1,
        bonus_h_dollars = 0,
        bonus_p_dollars = 0,
    }
    local active = false
    if not (self and self.ability and self.ability.bonus_x_mult) then
        active = true
    end
    local ret = oldfunc(self,center,initial,delay_sprites)
    if active == true then
        for k, v in pairs(bonus_abilities) do
            self.ability[k] = v
        end
    end
    return ret
end

local oldfunc = eval_card
function eval_card(card, context)
    context = context or {}
    local ret = oldfunc(card,context)
    if not card then return ret end
    if context.repetition_only then
        return ret
    end
    if context.cardarea == G.play then
        
        if card.ability.bonus_mult and card.ability.bonus_mult ~= 0 then
            ret.mult = ret.mult and ret.mult+card.ability.bonus_mult or card.ability.bonus_mult
        end

        if card.ability.bonus_x_mult and card.ability.bonus_x_mult ~= 1 then
            ret.x_mult = ret.x_mult and ret.x_mult*card.ability.bonus_x_mult or card.ability.bonus_x_mult
        end

        if card.ability.bonus_p_dollars and card.ability.bonus_p_dollars ~= 0 then
            ret.p_dollars = ret.p_dollars and ret.p_dollars+card.ability.bonus_p_dollars or card.ability.bonus_p_dollars
        end
    end

    if context.cardarea == G.hand then
        if card.ability.bonus_h_mult and card.ability.bonus_h_mult ~= 0 then
            ret.mult = ret.mult and ret.mult+card.ability.bonus_h_mult or card.ability.bonus_h_mult
        end
        if card.ability.bonus_h_x_mult and card.ability.bonus_h_x_mult ~= 1 then
            ret.x_mult = ret.x_mult and ret.x_mult*card.ability.bonus_h_x_mult or card.ability.bonus_h_x_mult
        end
    end

    return ret
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
