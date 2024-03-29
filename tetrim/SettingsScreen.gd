extends ColorRect

func _ready():

    $AudioBoxContainer/Music/MusicCheckButton.pressed = StoreSettings.audio_music
    $AudioBoxContainer/Sfx/SfxCheckButton.pressed = StoreSettings.audio_sfx
    $VideoBoxContainer/FullScreen/FullScreenCheckButton.pressed = StoreSettings.fullscreen


func _on_Quit_pressed():
    Utils.change_game_scene('res://TitleScreen.tscn')

    # Update StoreSettings variables
    StoreSettings.fullscreen = $VideoBoxContainer/FullScreen/FullScreenCheckButton.pressed
    StoreSettings.audio_music = $AudioBoxContainer/Music/MusicCheckButton.pressed
    StoreSettings.audio_sfx = $AudioBoxContainer/Sfx/SfxCheckButton.pressed

    # Save settings on file
    StoreSettings._save_settings()

func _on_FullScreenCheckButton_pressed():
    OS.window_fullscreen = !OS.window_fullscreen


func _on_MusicCheckButton_pressed():

    if $AudioBoxContainer/Music/MusicCheckButton.pressed:
        BackgroundMusic.play()
    else:
        BackgroundMusic.stop()
