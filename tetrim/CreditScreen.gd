extends Control

func _ready():
    $BackgroundMusic.play()


func _on_Quit_pressed():
    get_tree().change_scene("res://TitleScreen.tscn")
