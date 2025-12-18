package main

import "core:fmt"
import "core:math/rand"
import "core:math"
CardHouse :: enum {
    SPADES,
    HEARTS,
    CLUBS,
    DIAMONDS,
}

Card :: struct {
    value: int,
    house: CardHouse,
    remaining_disabled_turns: int,
}

get_card_effectiveness :: proc(card: Card) -> (value: int) {
    #partial switch card.house {
    case .SPADES:
        value = int(math.floor(f32(card.value) / 3)) + 1
        break
    case .HEARTS:
        value = int(math.floor(f32(card.value) / 4))
        break
    case .CLUBS:
        value = int(math.floor(f32(card.value) / 4))
    case .DIAMONDS:
        value = int(math.floor(f32(card.value) / 5))
    }

    return
}

get_card_cost :: proc(card: Card) -> int {
    if card.house == .DIAMONDS do return 0

    return max(int(math.ceil(f32(card.value) / 5)), 1)
}

get_random_card :: proc() -> Card {
    return Card{
        house=rand.choice_enum(CardHouse),
        value=rand.int_max(13),
    }
}

use_card :: proc(player: ^Player, card_idx: int, opponent: ^Player) {
    card := &player.card_hand[card_idx]

    card_hand := &player.card_hand

    card_cost := get_card_cost(card^)
    player.gold -= card_cost

    fmt.println(player.name, "USED CARD:", card, "FOR COST:", card_cost)

    #partial switch card.house {
    case .SPADES:
        player^.battle_card_idx = card_idx

        if opponent == &user {
            game_state = .PLAYER_CHOOSE_DEFENCE_CARD
        } else {
            game_state = .CPU_CHOOSE_DEFENCE_CARD
        }

        break
    case .CLUBS:
        // choose random card to disable
        card_idx := rand.int_max(len(opponent.card_hand))
        card_to_disable := &opponent.card_hand[card_idx]

        card_to_disable.remaining_disabled_turns = get_card_effectiveness(card^)
    case: 
        ordered_remove(&player.card_hand, card_idx)
    }
}