extends Control

# Create signals to update GUI
signal change_game_state

# Receive the nex block
var current_block

func _ready():
    get_node("CenterContainer/GameOverLabel").visible = false

func _on_Board_update_score(score, lines):
    # Update score and line numbers
    get_node("ContainerScore/ScoreBackground/ScoreValue").text = str(score)
    get_node("ContainerLines/LinesBackground/LinesCount").text = str(lines)


func _on_Board_update_next_block(next_block):

    if current_block:
        get_node("ContainerNextBlock/Background").remove_child(current_block)

    current_block = next_block
    current_block.position = get_node("ContainerNextBlock/Background/NextBlockPosition").position
    get_node("ContainerNextBlock/Background").add_child(current_block)


func _on_ButtonPauseResume_pressed():
    # Change button label and change game state

    if $ButtonContainer/ButtonPauseResume.text == 'PAUSE':
        $ButtonContainer/ButtonPauseResume.text = 'CONTINUE'
    else:
        $ButtonContainer/ButtonPauseResume.text = 'PAUSE'

    # Send signal to game to change state
    emit_signal("change_game_state")


func _on_ButtonQuit_pressed():
    get_tree().change_scene("res://TitleScreen.tscn")


func _on_Board_gameover():
    get_node("CenterContainer/GameOverLabel").visible = true
