package main

import rl "vendor:raylib"

main :: proc() {
    rl.InitWindow(1280, 720, "wow")

    init()

    for !rl.WindowShouldClose() {
        rl.BeginDrawing()

        rl.ClearBackground(rl.RAYWHITE)

        tick_input()

        rl.EndDrawing()
    }
}