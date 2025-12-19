package main

import "core:math/rand"
user : Player

user_set_battle_card :: proc() {
    user.battle_card_idx = rand.int_max(len(user.card_hand)-1)
}