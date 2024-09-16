#!/bin/bash
current_player='X'
board=(1 2 3 4 5 6 7 8 9 "$current_player")
board_file="game_save5.txt"
comp_or_human=''

# display the board
function display_board {
    echo " ${board[0]} | ${board[1]} | ${board[2]}"
    echo "---|---|---"
    echo " ${board[3]} | ${board[4]} | ${board[5]}"
    echo "---|---|---"
    echo " ${board[6]} | ${board[7]} | ${board[8]}"
}

# check if the game is over
function check_game_over {
    # check win
    local player=$1
    if [[ ${board[0]} == $player && ${board[1]} == $player && ${board[2]} == $player ]] ||
       [[ ${board[3]} == $player && ${board[4]} == $player && ${board[5]} == $player ]] ||
       [[ ${board[6]} == $player && ${board[7]} == $player && ${board[8]} == $player ]] ||
       [[ ${board[0]} == $player && ${board[3]} == $player && ${board[6]} == $player ]] ||
       [[ ${board[1]} == $player && ${board[4]} == $player && ${board[7]} == $player ]] ||
       [[ ${board[2]} == $player && ${board[5]} == $player && ${board[8]} == $player ]] ||
       [[ ${board[0]} == $player && ${board[4]} == $player && ${board[8]} == $player ]] ||
       [[ ${board[2]} == $player && ${board[4]} == $player && ${board[6]} == $player ]]; then
        echo "$player wins!"
        return 0
    fi
    # check tie
    for cell in "${board[@]}"; do
        if [[ $cell =~ ^[0-9]$ ]]; then
            return 1
        fi
    done
    echo "It's a tie!"
    return 2
}

# get player's move
function get_move {
    local player=$1
    local choice
    while true; do
        echo "Player $player, enter your move (1-9): "
        read -r choice
        if [[ $choice == 'e' ]]; then
            echo "Exiting the game..."; sleep 1;
            exit
        elif [[ $choice == 's' ]]; then
            save_game
        elif [[ $choice == 'l' ]]; then
            load_game
            display_board
        elif [[ $choice =~ ^[1-9]$ ]]; then
            if [[ ${board[$((choice-1))]} =~ [0-9] ]]; then
                board[$((choice-1))]=$player
                break
            else
                echo "Invalid move. This cell is already taken."
            fi
        else
            echo "Invalid input. Please enter a number from 1 to 9."
        fi
    done
}

function get_computer_move {
    # computer move
    local player=$1
    local available_moves=()
    for cells in "${!board[@]}"; do
        if [[ ${board[$cells]} =~ ^[0-9]$ ]]; then
            available_moves+=("$((cells+1))")
        fi
    done
    local random_index=$((RANDOM % ${#available_moves[@]}))
    local random_move=${available_moves[$random_index]}
    sleep 1
    echo "Computer (Player $player), choose cell $random_move"
    board[$((random_move-1))]=$player
}

# save the current game state
function save_game {
    board[9]="$current_player"
    echo "${board[*]}" > "$board_file"
    echo "Game saved."
}

# load the saved game state
function load_game {
    if [[ -f "$board_file" ]]; then
        read -r -a board <<< "$(cat "$board_file")"
        current_player=${board[9]}
        echo "Game loaded."
    else
        echo "No saved game found."
    fi
}

# main game loop
current_player='X'
while true; do
    echo "[Enter 'e' to exit, 's' to save current game, 'l' to load previously saved game]"
    while true; do
        read -p "Do you want to play against another player (p) or against the computer (c)? " choice
        case $choice in
            [Pp]* ) comp_or_human='P'; break ;;
            [Cc]* ) comp_or_human='C'; break ;;
            * ) echo "Please enter 'p' for playing against another player or 'c' for playing against the computer." ;;
        esac
    done

    current_player='X'
    while true; do
        display_board
        if [[ $comp_or_human == 'C' ]]; then # playing with computer
            if [[ $current_player == 'X' ]]; then
                get_move $current_player
            else
                get_computer_move $current_player
            fi
        else # playing against another player
            get_move $current_player
        fi
        check_game_over $current_player
        case $? in
            0) break ;;  # player wins
            1) if [[ $current_player == 'X' ]]; then
                   current_player='O'
               else
                   current_player='X'
               fi ;;
            2) break ;;  # a tie
        esac
    done
    read -p "Do you want to play again? (y/n): " choice
    clear;
    case $choice in
        [Yy]* ) board=(1 2 3 4 5 6 7 8 9) ;;
        [Nn]* ) echo "Exiting the game...";sleep 1; exit ;;
        * ) board=(1 2 3 4 5 6 7 8 9) ;;
    esac
done