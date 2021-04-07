extends Node


# Member variables here
var fullscreen
var audio_music
var config


# Called when the node enters the scene tree for the first time.
func _ready():
    _load_settings()

# Load settings file and load variables to Singleton node
func _load_settings():

    config = ConfigFile.new()

    var err = config.load("user://settings.cfg")

    if err == OK:
        fullscreen = config.get_value('display', 'fullscreen', false)
        audio_music = config.get_value('audio', 'music', true)
    else:
        fullscreen = false
        audio_music = true

# Save settings variables on file
func _save_settings():

    # Update settings values
    config.set_value("display", "fullscreen", fullscreen)
    config.set_value("audio", "music", audio_music)

    # Save the config file
    config.save("user://settings.cfg")
