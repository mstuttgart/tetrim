extends Control

func _on_Board_update_score(score, lines):
    # Update score and line numbers
    get_node("ContainerScore/ScoreBackground/ScoreValue").text = str(score)
    get_node("ContainerLines/LinesBackground/LinesCount").text = str(lines)
