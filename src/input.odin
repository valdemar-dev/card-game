package main

import "core:math/rand"
import "core:fmt"
import rl "vendor:raylib"

tick_input :: proc() {
    #partial switch game_state {
    case .MAIN_MENU:
        if rl.IsKeyPressed(.ENTER) {
            fmt.println("starting game..")

            start_game()
        }

        break
    case .PLAYER_CHOOSE_CARD:
        if rl.IsKeyPressed(.ENTER) {
            fmt.println("passing turn to cpu..")
            
            pass_turn_to(&cpu)
        }

        break
    case .PLAYER_CHOOSE_DEFENCE_CARD:
        if rl.IsKeyPressed(.ENTER) {
            fmt.println("(temp) PLAYER CHOOSING RAND CARD TO DEFEND WITH")

            user_set_battle_card()

            game_state = .CPU_ATTACK_FINISH
        }
    }
}