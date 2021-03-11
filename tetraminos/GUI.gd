extends Control

var current_block

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
