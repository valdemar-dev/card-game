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
            
            game_state = .DO_PASS_TURN
        }

        break
    case .USER_CHOOSE_DEFENCE_CARD:
        if rl.IsMouseButtonPressed(.LEFT) {
            user_try_set_defence_card()
        }

        // forfeit the attack and set no defence card
        if rl.IsKeyPressed(.ENTER) {
            game_state = .CPU_ATTACK_FINISH
        }
    }
}