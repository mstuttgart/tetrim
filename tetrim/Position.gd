extends Position2D


# Declare member variables here
var _tile_list = []

func _ready():
    _tile_list = []

func get_tile_list():
    return _tile_list

func tile_list_size():
    return _tile_list.size()

func clear_tile_list():
    _tile_list.clear()

func append_tile(tile):
    _tile_list.append(tile)

func tile_list_is_empty():
    return _tile_list.empty()

func destroy_tiles():

    # Delete shapes in list
    for tile in _tile_list:

        # Remove tile from tree scene and delete it
        if tile.get_parent():
            tile.get_parent().remove_child(tile)
            tile.remove_from_group("StuckBlocks")
            tile.free()

    # Clear the list
    clear_tile_list()
