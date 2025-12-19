package main

import "core:math/rand"
import "core:fmt"
import rl "vendor:raylib"

tick_input :: proc() {
    #partial switch game_state {
    case .MAIN_MENU:
        if rl.IsKeyPressed(.ENTER) {
            start_game()
        }

        break
    case .USER_CHOOSE_CARD:
        if rl.IsMouseButtonPressed(.LEFT) {
            user_try_use_card()
        }
        
        if rl.IsKeyPressed(.ENTER) {
            fmt.println("passing turn to cpu..")
            
            append(&tasks, proc() {
                pass_turn_to(&cpu)
            })
        }

        break
    case .USER_CHOOSE_DEFENCE_CARD:
        if rl.IsKeyPressed(.ENTER) {
            fmt.println("(temp) PLAYER CHOOSING RAND CARD TO DEFEND WITH")

            user_set_battle_card()

            game_state = .CPU_ATTACK_FINISH
        }
    }
}