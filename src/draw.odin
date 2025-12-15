package main

import "core:fmt"
import rl "vendor:raylib"

draw :: proc() {
    rl.BeginDrawing()

    rl.ClearBackground(rl.RAYWHITE)

    #partial switch game_state {
    case .MAIN_MENU:
        draw_main_menu()
        break
    case .GAME_OVER:
        draw_game_over()
        break
    case:
        draw_game()
    }

    rl.EndDrawing()
}

draw_game :: proc() {
    draw_cards()

    draw_user_stats()
    draw_cpu_stats()

}

draw_cards :: proc() {
    width, height := f32(rl.GetRenderWidth()), f32(rl.GetRenderHeight())

    card_width : f32 = 128
    raw_card_aspect :=  f32(raw_card_height) / f32(raw_card_width)
    card_height := card_width * raw_card_aspect

    padding_x :: 20
    padding_y :: 80

    // user cards
    {
        user_card_pos := rl.Vector2{
            padding_x,
            height - card_height - padding_y,
        }

        pen := user_card_pos

        for card in user.card_hand {
            defer pen.x += card_width + padding_x / 2

            src := get_card_region(card)

            dst := rl.Rectangle{
                pen.x,
                pen.y,
                card_width,
                card_height,
            }

            rl.DrawTexturePro(card_atlas, src, dst, rl.Vector2{}, 0, rl.WHITE)
        }   
    }

    // cpu cards
    {
        cpu_card_pos := rl.Vector2{
            padding_x,
            padding_y,
        }

        pen := cpu_card_pos

        for card in cpu.card_hand {
            defer pen.x += card_width + padding_x / 2

            src := get_card_region(card)

            dst := rl.Rectangle{
                pen.x,
                pen.y,
                card_width,
                card_height,
            }

            rl.DrawTexturePro(card_atlas, src, dst, rl.Vector2{}, 0, rl.WHITE)
        }   
    }
}

draw_user_stats :: proc() {}

draw_cpu_stats :: proc() {

}

draw_game_over :: proc() {
    rl.DrawTextPro(font, "The game has ended", rl.Vector2{}, rl.Vector2{}, 0, 20, 1.5, rl.BLACK)
}

draw_main_menu :: proc() {
    rl.DrawTextPro(font, "Press Enter to start the game", rl.Vector2{}, rl.Vector2{}, 0, 20, 1.5, rl.BLACK)
}
