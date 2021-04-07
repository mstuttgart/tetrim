extends Control

func _ready():
    # Enable/disable fullscreen from settings
    OS.window_fullscreen = StoreSettings.fullscreen

    $FadeBackground.visible = true
    $FadeBackground/AnimationPlayer.play("FadeIn")


func _on_Play_pressed():
    $FadeBackground.visible = true
    $FadeBackground/AnimationPlayer.play("FadeOut")


func _on_AnimationPlayer_animation_finished(anim_name):

    if anim_name == 'FadeOut':
        Utils.change_game_scene('res://Game.tscn')
    else:
        $FadeBackground.visible = false


func _on_Quit_pressed():
    get_tree().quit()


func _on_Credits_pressed():
    Utils.change_game_scene('res://CreditScreen.tscn')


func _on_Settings_pressed():
    Utils.change_game_scene('res://SettingsScreen.tscn')
