package main

import "core:time"
import "core:fmt"
import "core:math/rand"
cpu : Player

cpu_choose_card :: proc() {
    time.sleep(time.Second * 2)

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
    time.sleep(time.Second * 2)

    attack_card := &cpu.card_hand[cpu.battle_card_idx]
    defer cpu.battle_card_idx = -1
    defer ordered_remove(&cpu.card_hand, cpu.battle_card_idx)

    defence_card := &user.card_hand[user.battle_card_idx]
    defer user.battle_card_idx = -1
    defer ordered_remove(&user.card_hand, user.battle_card_idx)

    if defence_card.remaining_disabled_turns > 0 do panic("Disabled card used at defence card for user.")
    if attack_card.remaining_disabled_turns > 0 do panic("Disabled card used at attack card for cpu.")
    
    attack := get_card_effectiveness(attack_card^)
    defence := int(f32(get_card_effectiveness(defence_card^)) / 2)

    fmt.println("CPU ATTACK CARD:", attack_card)
    fmt.println("USER DEFENCE CARD:", defence_card)

    time.sleep(time.Second * 2)

    damage := max(attack - defence, 0)

    user.crown_health -= damage

    fmt.println("USER TAKES", damage, "DAMAGE")

    time.sleep(time.Second * 2)

    if user.crown_health < 1 {
        end_game(.GAME_OVER)

        return
    }

    game_state = .CPU_CHOOSE_CARD
}