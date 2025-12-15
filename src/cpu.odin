package main

import "core:fmt"
import "core:math/rand"
cpu : Player

cpu_choose_card :: proc() {
    // get every card it can afford
    // pick one at random
    affordable_cards : [dynamic]int
    defer delete(affordable_cards)

    for card, index in cpu.card_hand {
        cost := get_card_cost(card)
        if cost <= cpu.gold do append(&affordable_cards, index)
    }

    if len(affordable_cards) == 0 {
        pass_turn_to(&user)
        
        fmt.println("CPU PASSING TURN TO USER")
        return
    }

    // choice for this run
    {
        card_idx := rand.choice(affordable_cards[:])

        use_card(&cpu, card_idx, &user)
    }
}

cpu_choose_defence_card :: proc() {}

cpu_finish_attack :: proc() {
    attack_card := &cpu.card_hand[cpu.battle_card_idx]
    defer cpu.battle_card_idx = -1
    defer ordered_remove(&cpu.card_hand, cpu.battle_card_idx)

    defence_card := &user.card_hand[user.battle_card_idx]
    defer user.battle_card_idx = -1
    defer ordered_remove(&user.card_hand, user.battle_card_idx)
    
    attack := get_card_effectiveness(attack_card^)
    defence := int(f32(get_card_effectiveness(defence_card^)) / 2)

    fmt.println("CPU ATTACK CARD:", attack_card)
    fmt.println("USER DEFENCE CARD:", defence_card)

    damage := max(attack - defence, 0)

    user.crown_health -= damage

    fmt.println("USER TAKES", damage, "DAMAGE")

    game_state = .CPU_CHOOSE_CARD

    if user.crown_health < 1 {
        end_game(.GAME_OVER)

        return
    }
}