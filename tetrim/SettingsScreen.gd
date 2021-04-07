extends ColorRect

func _ready():

    if StoreSettings.audio_music:
        $BackgroundMusic.play()

    $AudioBoxContainer/Music/MusicCheckButton.pressed = StoreSettings.audio_music
    $VideoBoxContainer/FullScreen/FullScreenCheckButton.pressed = StoreSettings.fullscreen


func _on_Quit_pressed():
    get_tree().change_scene("res://TitleScreen.tscn")

    # Update StoreSettings variables
    StoreSettings.fullscreen = $VideoBoxContainer/FullScreen/FullScreenCheckButton.pressed
    StoreSettings.audio_music = $AudioBoxContainer/Music/MusicCheckButton.pressed

    # Save settings on file
    StoreSettings._save_settings()

func _on_FullScreenCheckButton_pressed():
    OS.window_fullscreen = !OS.window_fullscreen


func _on_MusicCheckButton_pressed():

    if $AudioBoxContainer/Music/MusicCheckButton.pressed:
        $BackgroundMusic.play()
    else:
        $BackgroundMusic.stop()
