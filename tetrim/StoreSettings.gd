extends Node


# Member variables here
var fullscreen
var config


# Called when the node enters the scene tree for the first time.
func _ready():
    _load_settings()

# Load settings file and load variables to Singleton node
func _load_settings():

    config = ConfigFile.new()

    var err = config.load("user://settings.cfg")

    if err == OK:
        pass
        fullscreen = config.get_value('display', 'fullscreen', false)
    else:
        fullscreen = false

# Save settings variables on file
func _save_settings():

    # Update settings values
    config.set_value("display", "fullscreen", fullscreen)

    # Save the config file
    config.save("user://settings.cfg")
