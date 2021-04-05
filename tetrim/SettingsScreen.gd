extends ColorRect

func _ready():
    $BackgroundMusic.play()
    $MenuContainer/HBoxContainer2/CheckButton.pressed = StoreSettings.fullscreen


func _on_Quit_pressed():
    get_tree().change_scene("res://TitleScreen.tscn")

    # Update StoreSettings variables
    StoreSettings.fullscreen = OS.window_fullscreen

    # Save settings on file
    StoreSettings._save_settings()

func _on_CheckButton_pressed():
    OS.window_fullscreen = !OS.window_fullscreen
