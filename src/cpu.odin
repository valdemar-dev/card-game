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
        game_state = .DO_PASS_TURN
        
        fmt.println("CPU PASSING TURN TO USER")

        return
    }

    // choice for this run
    {
        card_idx := rand.choice(affordable_cards[:])

        use_card(&cpu, card_idx, &user)
    }
}

cpu_choose_defence_card :: proc() {
    cpu.battle_card_idx = rand.int_max(len(cpu.card_hand)-1)

    game_state = .USER_ATTACK_FINISH
}