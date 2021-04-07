extends Node

func print_log(message):

    # Get datetime to dictionary
    var dt=OS.get_datetime()

    # Format and print with message
    print("%02d:%02d:%02d " % [dt.hour,dt.minute,dt.second], message)

    return true

func change_game_scene(scene):

    var err = get_tree().change_scene(scene)

    if err == OK:
        assert(print_log("Success to change scene. Scene: %s" % scene))

    elif err == ERR_CANT_OPEN:
        assert(print_log('The path cannot be loaded into a PackedScene. Scene: %s' % scene))

    elif err == ERR_CANT_CREATE:
        assert(print_log(' if that scene cannot be instantiated. Scene: %s' % scene))

    else:
        assert(print_log('Unknow error occurred in loand scene. Scene: %s' % scene))

