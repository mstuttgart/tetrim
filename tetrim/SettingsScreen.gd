extends ColorRect

func _ready():
    $BackgroundMusic.play()


func _on_Quit_pressed():
    get_tree().change_scene("res://TitleScreen.tscn")


func _on_CheckButton_pressed():
    OS.window_fullscreen = !OS.window_fullscreen
