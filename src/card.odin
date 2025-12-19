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
        value = max(int(math.floor(f32(card.value) / 4)), 1)
        break
    case .CLUBS:
        value = max(int(math.floor(f32(card.value) / 4)), 1)
    case .DIAMONDS:
        value = max(int(math.floor(f32(card.value) / 5)), 1)
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
        value=rand.int_max(12)+1,
    }
}

use_card :: proc(player: ^Player, card_idx: int, opponent: ^Player) {
    card := &player.card_hand[card_idx]

    card_hand := &player.card_hand

    card_cost := get_card_cost(card^)
    player.gold -= card_cost

    fmt.println(player.name, "using card:", card.value, card.house)

    #partial switch card.house {
    case .SPADES:
        player^.battle_card_idx = card_idx

        if opponent == &user {
            game_state = .USER_CHOOSE_DEFENCE_CARD
        } else {
            game_state = .CPU_CHOOSE_DEFENCE_CARD
        }

        fmt.println(player.name, "begun an attack on", opponent.name, "using a spade card.")

        break
    case .CLUBS:
        // choose random card to disable
        disabled_card_idx := rand.int_max(len(opponent.card_hand))
        card_to_disable := &opponent.card_hand[disabled_card_idx]

        card_to_disable.remaining_disabled_turns = get_card_effectiveness(card^)

        fmt.println(player.name, "used a clubs card, and disabled card with index:", disabled_card_idx)

        ordered_remove(&player.card_hand, card_idx)

        break
    case .HEARTS:
        effectiveness := get_card_effectiveness(card^)
        player^.crown_health = clamp(player.crown_health + effectiveness, 0, MAX_HEALTH)

        fmt.println(player.name, "used a hearts card, and healed themselves for", effectiveness, "health. (clamped)")

        ordered_remove(&player.card_hand, card_idx)

        break
    case .DIAMONDS:
        gold := get_card_effectiveness(card^)
        player^.gold = clamp(player.gold + gold, 0, MAX_GOLD)

        fmt.println(player.name, "used a diamonds card, and got", gold, "gold (clamped).")

        ordered_remove(&player.card_hand, card_idx)

        break
    }

}