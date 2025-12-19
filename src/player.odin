package main

import "core:fmt"
import "core:time"
pass_turn_to :: proc(player: ^Player) {
    // a full turn has occured.
    if player == first_turn_holder{
        increment_turn()
    }

    end_player_turn(player)

    if player == &cpu {
        game_state = .CPU_CHOOSE_CARD
        start_player_turn(&cpu)
    } else {
        game_state = .USER_CHOOSE_CARD
        start_player_turn(&user)
    }
}

end_player_turn :: proc(player: ^Player) {
    for i := 0; i < 3 && len(player.card_hand) < 7; i += 1 {
        time.sleep(time.Second * 1)

        append(&(player^.card_hand), get_random_card())
    }
}

start_player_turn :: proc(player: ^Player) {
    player^.gold = clamp(turn_count, 2, 10)

}

finish_attack :: proc(player: ^Player, target: ^Player) -> (did_kill: bool) {
    time.sleep(time.Second * 2)

    attack_card := &user.card_hand[cpu.battle_card_idx]
    defer user.battle_card_idx = -1
    defer ordered_remove(&user.card_hand, user.battle_card_idx)

    defence_card := &cpu.card_hand[cpu.battle_card_idx]
    defer cpu.battle_card_idx = -1
    defer ordered_remove(&cpu.card_hand, cpu.battle_card_idx)

    if defence_card.remaining_disabled_turns > 0 do panic("Disabled card used at defence card for user.")
    if attack_card.remaining_disabled_turns > 0 do panic("Disabled card used at attack card for cpu.")
    
    attack := get_card_effectiveness(attack_card^)
    defence := int(f32(get_card_effectiveness(defence_card^)) / 2)

    fmt.println("USER ATTACK CARD:", attack_card)
    fmt.println("CPU DEFENCE CARD:", defence_card)

    time.sleep(time.Second * 2)

    damage := max(attack - defence, 0)

    user.crown_health -= damage

    fmt.println("USER TAKES", damage, "DAMAGE")

    time.sleep(time.Second * 2)

    if user.crown_health < 1 {
        end_game(.GAME_OVER)

        did_kill = true
        return
    }

    return
}