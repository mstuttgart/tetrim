extends Control

# Create signals to update GUI
signal change_game_state
signal restart_game

# Receive the nex block
var current_block

func _ready():
    $CenterContainer/GameOverLabel.visible = false
    $CenterContainer/PauseLabel.visible = false

func _on_Board_update_score(score, lines):
    # Update score and line numbers
    $ContainerScore/ScoreBackground/ScoreValue.text = str(score)
    $ContainerLines/LinesBackground/LinesCount.text = str(lines)


func _on_Board_update_next_block(next_block):

    if current_block:
        $ContainerNextBlock/Background.remove_child(current_block)

    current_block = next_block
    current_block.position = $ContainerNextBlock/Background/NextBlockPosition.position
    $ContainerNextBlock/Background.add_child(current_block)


func _on_ButtonPauseResume_pressed():
    # Change button label and change game state

    if $ButtonContainer/ButtonPauseResume.text == 'PAUSE':
        $ButtonContainer/ButtonPauseResume.text = 'CONTINUE'
        $CenterContainer/PauseLabel.visible = true
    else:
        $ButtonContainer/ButtonPauseResume.text = 'PAUSE'
        $CenterContainer/PauseLabel.visible = false

    # Send signal to game to change state
    emit_signal("change_game_state")


func _on_ButtonQuit_pressed():
    Utils.change_game_scene('res://TitleScreen.tscn')


func _on_Board_gameover():
    $CenterContainer/GameOverLabel.visible = true
    $ButtonContainer/ButtonRetry.visible = true
    $ButtonContainer/ButtonPauseResume.visible = false


func _on_ButtonRetry_pressed():
    $CenterContainer/GameOverLabel.visible = false
    $ButtonContainer/ButtonRetry.visible = false
    $ButtonContainer/ButtonPauseResume.visible = true
    emit_signal("restart_game")
