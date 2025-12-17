package main

import "core:reflect"
import "core:strings"
import rl "vendor:raylib"
import "core:fmt"

camera : rl.Camera2D
font : rl.Font

raw_card_width : i32
raw_card_height : i32

card_atlas : rl.Texture2D

get_card_filename :: proc(card: Card) -> string {
    value_str: string
    append_variant := false

    switch card.value {
    case 1: 
        value_str = "ace"
    case 2..=10: 
        value_str = fmt.tprint(card.value)
    case 11: 
        value_str = "jack"
    case 12: 
        value_str = "queen"
        append_variant = true
    case 13: 
        value_str = "king"
        append_variant = true
    }
    
    house_str := strings.to_lower(reflect.enum_string(card.house))
    builder := strings.builder_make()

    defer strings.builder_destroy(&builder)

    strings.write_string(&builder, value_str)
    strings.write_string(&builder, "_of_")
    strings.write_string(&builder, house_str)

    if append_variant {
        strings.write_string(&builder, "2")
    }

    strings.write_string(&builder, ".png")

    return strings.clone(strings.to_string(builder))
}

get_card_region :: proc(card: Card) -> rl.Rectangle {
    col := card.value - 1
    row := int(card.house)

    return rl.Rectangle{f32(col) * f32(raw_card_width), f32(row) * f32(raw_card_height), f32(raw_card_width), f32(raw_card_height)}
}

init_assets :: proc() {
    font = rl.LoadFont("./src/assets/fonts/Inter/Inter-VariableFont_opsz,wght.ttf")
    rl.GuiSetFont(font)

    big: rl.Image
    first := true

    for h in 0..<4 {
        house := CardHouse(h)
        
        for v in 1..=13 {
            card := Card{v, house}

            filename := get_card_filename(card)
            defer delete(filename)

            path := fmt.tprintf("./src/assets/card_images/%s", filename)
            img := rl.LoadImage(cstring(raw_data(path)))

            if first {
                raw_card_width = img.width
                raw_card_height = img.height

                atlas_width := i32(13) * raw_card_width
                atlas_height := i32(4) * raw_card_height

                big = rl.GenImageColor(i32(atlas_width), i32(atlas_height), rl.BLANK)
                
                first = false
            }

            col := v - 1
            row := h

            src_rect := rl.Rectangle{0, 0, f32(img.width), f32(img.height)}
            dst_rect := rl.Rectangle{f32(col) * f32(raw_card_width), f32(row) * f32(raw_card_height), f32(raw_card_width), f32(raw_card_height)}

            rl.ImageDraw(&big, img, src_rect, dst_rect, rl.WHITE)
            rl.UnloadImage(img)
        }
    }

    card_atlas = rl.LoadTextureFromImage(big)

    rl.UnloadImage(big)
}

init :: proc() {
    init_assets()
}