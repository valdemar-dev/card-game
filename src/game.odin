package main

import "core:fmt"
import "core:time"
import "core:thread"
import rl "vendor:raylib"

GameState :: enum {
    MAIN_MENU,

    PLAYER_CHOOSE_CARD,
    PLAYER_ATTACK_FINISH,
    CPU_CHOOSE_DEFENCE_CARD,
    
    CPU_CHOOSE_CARD,
    CPU_ATTACK_FINISH,
    PLAYER_CHOOSE_DEFENCE_CARD,

    GAME_OVER,
}

game_state : GameState = .MAIN_MENU


Player :: struct {
    card_hand: [dynamic]Card,
    name: string,
    gold: int,
    crown_health: int,
    battle_card_idx: int,
}

game_thread : ^thread.Thread
start_game :: proc() {
    game_state = .PLAYER_CHOOSE_CARD

    game_thread = thread.create(tick_game)
    thread.start(game_thread)

    // init cpu
    {
        clear(&cpu.card_hand)
        for i in 0..<7 {
            append(&cpu.card_hand, get_random_card())
        }

        cpu.crown_health = 15
        cpu.name = "CPU"
    }

    // init player
    {
        clear(&user.card_hand)
        for i in 0..<7 {
            append(&user.card_hand, get_random_card())
        }

        user.crown_health = 15
        user.name = "USER"
    }
}

tasks : [dynamic]proc()
tick_game :: proc(thread: ^thread.Thread) {
    last_time : f64

    desired_frame_time : f64 = 1 / 60

    for {
        // simple task system
        {
            current_time := rl.GetTime()

            delta := current_time - last_time
            if delta < desired_frame_time {
                time.sleep(time.Duration(desired_frame_time - delta) * time.Second)
            }

            for task, index in tasks {
                task()

                unordered_remove(&tasks, index)
            }
        }

        // cpu ai, if needed
        #partial switch game_state {
        case .CPU_CHOOSE_CARD:
            cpu_choose_card()
            break
        case .CPU_ATTACK_FINISH:
            cpu_finish_attack()
            break
        case .CPU_CHOOSE_DEFENCE_CARD:
            cpu_choose_defence_card()
            break
        }
    }
}

end_game :: proc(state: GameState) {
    game_state = state

    fmt.println("GAME HAS ENDED:", state)
}