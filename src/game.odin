package main

import "core:fmt"
import "core:time"
import "core:thread"
import rl "vendor:raylib"

GameState :: enum {
    MAIN_MENU,

    USER_CHOOSE_CARD,
    USER_ATTACK_FINISH,
    CPU_CHOOSE_DEFENCE_CARD,

    DO_PASS_TURN,
    
    CPU_CHOOSE_CARD,
    CPU_ATTACK_FINISH,
    USER_CHOOSE_DEFENCE_CARD,

    GAME_OVER,
}

MAX_GOLD :: 15
MAX_HEALTH :: 20
STARTING_HEALTH :: 15

game_state : GameState = .MAIN_MENU

turn_count : int

Player :: struct {
    card_hand: [dynamic]Card,
    name: string,
    gold: int,
    crown_health: int,
    battle_card_idx: int,
}

// a pointer to the first person who held a turn in the game.
// is used for knowing when a "full turn" has occured.
first_turn_holder : ^Player

game_thread : ^thread.Thread
start_game :: proc() {
    // init cpu
    {
        clear(&cpu.card_hand)
        for i in 0..<7 {
            append(&cpu.card_hand, get_random_card())
        }

        cpu.crown_health = STARTING_HEALTH
        cpu.name = "CPU"
    }

    // init player
    {
        clear(&user.card_hand)
        for i in 0..<7 {
            append(&user.card_hand, get_random_card())
        }

        user.crown_health = STARTING_HEALTH
        user.name = "USER"
    }

    game_state = .USER_CHOOSE_CARD
    start_player_turn(&user)

    game_thread = thread.create(tick_game)
    thread.start(game_thread)

    prev_turn_holder = &cpu
    turn_holder = &user

    first_turn_holder = &user
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

                fmt.println("did a task")

                unordered_remove(&tasks, index)
            }
        }

        // cpu ai, if needed
        #partial switch game_state {
        case .DO_PASS_TURN:
            pass_turn_to(prev_turn_holder)

            break
        case .CPU_CHOOSE_CARD:
            cpu_choose_card()

            break
        case .CPU_ATTACK_FINISH:
            did_kill := finish_attack(&cpu, &user)

            if did_kill {
                game_state = .GAME_OVER
            } else {
                game_state = .CPU_CHOOSE_CARD
            }

            break
        case .CPU_CHOOSE_DEFENCE_CARD:
            cpu_choose_defence_card()

            break
        case .USER_ATTACK_FINISH:
            did_kill := finish_attack(&user, &cpu)

            if did_kill {
                game_state = .GAME_OVER
            } else {
                game_state = .USER_CHOOSE_CARD
            }

            break
        }
    }
}

increment_turn :: proc() {
    turn_count += 1

    for &card in user.card_hand {
        if card.remaining_disabled_turns > 0 {
            card.remaining_disabled_turns -= 1
        }
    }

    for &card in cpu.card_hand {
        if card.remaining_disabled_turns > 0 {
            card.remaining_disabled_turns -= 1
        }
    }
}

end_game :: proc(state: GameState) {
    game_state = state

    first_turn_holder = nil

    fmt.println("GAME HAS ENDED:", state)
}