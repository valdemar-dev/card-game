package main

import rl "vendor:raylib"

main :: proc() {
    rl.InitWindow(1280, 720, "wow")

    init()

    for !rl.WindowShouldClose() {

        tick_input()
        draw()
    }
}