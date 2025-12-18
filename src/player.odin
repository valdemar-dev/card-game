package main

pass_turn_to :: proc(player: ^Player) {
    // a full turn has occured.
    if player == first_turn_holder{
        increment_turn()
    }

    if player == &cpu {
        game_state = .CPU_CHOOSE_CARD
        start_player_turn(&cpu)
    } else {
        game_state = .PLAYER_CHOOSE_CARD
        start_player_turn(&user)
    }
}

start_player_turn :: proc(player: ^Player) {
    player^.gold = min(turn_count, 10)

    for i := 0; i < 3 && len(player.card_hand) < 7; i += 1 {
        append(&(player^.card_hand), get_random_card())
    }
}