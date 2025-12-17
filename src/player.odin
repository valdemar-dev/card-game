package main

pass_turn_to :: proc(player: ^Player) {
    if player == &cpu {
        game_state = .CPU_CHOOSE_CARD
        start_player_turn(&cpu)
    } else {
        game_state = .PLAYER_CHOOSE_CARD
        start_player_turn(&user)
    }
}

start_player_turn :: proc(player: ^Player) {
    player^.gold = 2

    for len(player.card_hand) < 7 {
        append(&(player^.card_hand), get_random_card())
    }
}