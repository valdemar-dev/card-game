package main

import "core:time"
import "core:fmt"
import "core:math/rand"
import rl "vendor:raylib"

user : Player

user_card_click_rects : [dynamic]rl.Rectangle

user_set_battle_card :: proc() {
    user.battle_card_idx = rand.int_max(len(user.card_hand)-1)
}

user_try_use_card :: proc() {
    pos := rl.GetMousePosition()

    for rect, card_idx in user_card_click_rects {
        if !rl.CheckCollisionPointRec(pos, rect) do continue

        target_card := &user.card_hand[card_idx]
        
        if user.gold < get_card_cost(target_card^) {
            fmt.println("player cannot afford this card.")

            return
        }

        if target_card.remaining_disabled_turns > 0 {
            return
        }
        
        use_card(&user, card_idx, &cpu)
    }
}

user_try_set_defence_card :: proc() {
    pos := rl.GetMousePosition()

    for rect, card_idx in user_card_click_rects {
        if !rl.CheckCollisionPointRec(pos, rect) do continue

        target_card := &user.card_hand[card_idx]

        if target_card.remaining_disabled_turns > 0 {
            // todo: play little thump or something
            return
        }

        user.battle_card_idx = card_idx
        game_state = .CPU_ATTACK_FINISH
    }
}