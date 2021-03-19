extends Node2D

# Create signals to update GUI
signal update_score
signal update_next_block
signal gameover

# States of game
enum States { STOP, PLAY, PAUSE }

# Keeps track of the current state
var _state = States.STOP

# Declare member const here.
const TILE_SIZE = 32

# Declare member variables here.
var block_list = [
    preload("res://blocks/S.tscn"),
    preload("res://blocks/L.tscn"),
    preload("res://blocks/J.tscn"),
    preload("res://blocks/T.tscn"),
    preload("res://blocks/Z.tscn"),
    preload("res://blocks/O.tscn"),
    preload("res://blocks/I.tscn"),
]

var tile_scene = preload("res://blocks/Tile.tscn")

# Flag to stop down block
var stop_block = 0

# player block node
var player_block
var next_block

# Vector to move down
var velocity_down

# Player score
var score = 0
var lines = 0

# Called when the node enters the scene tree for the first time.
func _ready():
    # Setups a time-based seed to generator.
    randomize()

    # Reset score
    score = 0
    lines = 0
    emit_signal("update_score", score, lines)

    # Instance vector
    velocity_down = Vector2(0, 1).normalized() * TILE_SIZE

    # Start timer of falling block
    $FallingTimer.start()

    # Load player block
    _get_player_block()

    # Active state on PLAY
    _state = States.PLAY


# Called every frame. 'delta' is the elapsed time since the previous frame.
# warning-ignore:unused_argument
func _process(delta):

    if _state != States.PLAY:
        return

    var velocity = Vector2()

    if Input.is_action_just_pressed("ui_up"):

        # Rotate block and check collision rotate
        player_block.rotate_block()

    elif Input.is_action_just_pressed("ui_left"):
        velocity.x -= 1

    elif Input.is_action_just_pressed("ui_right"):
        velocity.x += 1

    elif Input.is_action_just_pressed("ui_down"):
        velocity.y += 2
        score += 2
        emit_signal("update_score", score, lines)

    if velocity.length() > 0:
        velocity = velocity * TILE_SIZE

    player_block.move_and_collide(velocity)


func _get_player_block():

    if player_block:
        remove_child(player_block)
        player_block.queue_free()

    # Instance player block
    if next_block:
        player_block = next_block
    else:
        player_block = get_next_block()

    # Create next block and send it to show in GUI
    next_block = get_next_block()
    emit_signal("update_next_block", next_block)

    player_block.position = $StartPosition.position

    # Add player to board tree
    add_child(player_block)

func get_next_block():
    return block_list[randi() % block_list.size()].instance()

func _clear_line():

    # store complete line index from list
    var completed_line_index_list = []
    var index = 0

    for pos in $PositionCursor.get_children():

        pos.clear_tile_list()

        for tile in get_tree().get_nodes_in_group('StuckBlocks'):

            if tile.position.y == pos.get_global_position().y:
                pos.append_tile(tile)

        # Area is complete (10 blocks)
        if pos.tile_list_size() == 10:

            # Delete shapes in list
            pos.destroy_tiles()

            completed_line_index_list.append(index)

        index += 1

    # Move the tile lines down
    for idx in completed_line_index_list:

        for pos in $PositionCursor.get_children().slice(idx, $PositionCursor.get_children().size() - 1):

            for tile in pos.get_tile_list():
                tile.position += velocity_down

    if completed_line_index_list.size():
        score += 100 * pow(2, completed_line_index_list.size() - 1)
        lines += completed_line_index_list.size()

        # Update score and line on GUI
        emit_signal("update_score", score, lines)

func _on_FallingTimer_timeout():

    if _state != States.PLAY:
        return

    player_block.move_and_collide(velocity_down)

    var transform2d = Transform2D(player_block.rotation, player_block.position + position)

    if player_block.test_move(transform2d, velocity_down * 0.5, false) and stop_block != 2:
        stop_block += 1

    if stop_block == 2:
        # Block not can fall
        stop_block = 0

        # Save current player block to group
        for tile in player_block.get_children():

            # Create tile and insert it in scene tree
            var tile_body = tile_scene.instance()

            tile_body.position = tile.get_global_position() - position
            tile_body.get_node("Sprite").modulate = tile.get_node("Sprite").modulate
            add_child(tile_body)

        # Generate a new block to player
        _get_player_block()

        # Check complete lines and clean then
        _clear_line()

func _on_Roof_body_entered(body):
    _state = States.STOP
    emit_signal("gameover")

func _on_GUI_change_game_state():

    if _state == States.PLAY:
        _state = States.PAUSE
        $FallingTimer.stop()

    elif _state == States.PAUSE:
        _state = States.PLAY
        $FallingTimer.start()
