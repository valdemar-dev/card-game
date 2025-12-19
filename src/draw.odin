package main

import "core:strings"
import "core:fmt"
import rl "vendor:raylib"

draw :: proc() {
    rl.BeginDrawing()

    rl.ClearBackground(rl.BLACK)

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

    draw_stats()
}

draw_cards :: proc() {
    width, height := f32(rl.GetRenderWidth()), f32(rl.GetRenderHeight())

    card_width : f32 = 128
    raw_card_aspect :=  f32(raw_card_height) / f32(raw_card_width)
    card_height := card_width * raw_card_aspect

    padding_x :: 20
    padding_y :: 100

    // user cards
    {
        clear(&user_card_click_rects)

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

            append(&user_card_click_rects, dst)

            color := card.remaining_disabled_turns > 0 ? rl.GRAY : rl.WHITE

            rl.DrawTexturePro(card_atlas, src, dst, rl.Vector2{}, 0, color)
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

            color := card.remaining_disabled_turns > 0 ? rl.GRAY : rl.WHITE

            rl.DrawTexturePro(card_atlas, src, dst, rl.Vector2{}, 0, color)
        }   
    }
}

draw_stats :: proc() {
    width, height := f32(rl.GetRenderWidth()), f32(rl.GetRenderHeight())

    padding_x :: 20
    padding_y :: 20

    // draw user stats
    {
        sb := strings.builder_make()
        defer strings.builder_destroy(&sb)

        {
            strings.write_string(&sb, "Crown Health:")
            strings.write_int(&sb, user.crown_health)

            strings.write_string(&sb, "\nGold:")
            strings.write_int(&sb, user.gold)
        }

        user_stats_pos := rl.Vector2{
            padding_x,
            height - padding_y * 3,
        }

        pen := user_stats_pos

        rl.DrawTextPro(font, strings.to_cstring(&sb), pen, rl.Vector2{}, 0, 20, 1.5, rl.WHITE)
    }

    // draw cpu stats
    {
        cpu_stats_pos := rl.Vector2{
            padding_x,
            padding_y,
        }

        pen := cpu_stats_pos

        sb := strings.builder_make()
        defer strings.builder_destroy(&sb)

        {
            strings.write_string(&sb, "Crown Health:")
            strings.write_int(&sb, cpu.crown_health)

            strings.write_string(&sb, "\nGold:")
            strings.write_int(&sb, cpu.gold)
        }

        rl.DrawTextPro(font, strings.to_cstring(&sb), pen, rl.Vector2{}, 0, 20, 1.5, rl.WHITE)
    }
}

draw_game_over :: proc() {
    rl.DrawTextPro(font, "The game has ended", rl.Vector2{}, rl.Vector2{}, 0, 20, 1.5, rl.WHITE)
}

draw_main_menu :: proc() {
    rl.DrawTextPro(font, "Press Enter to start the game", rl.Vector2{}, rl.Vector2{}, 0, 20, 1.5, rl.WHITE)
}
