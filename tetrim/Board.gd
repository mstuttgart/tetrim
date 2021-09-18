extends Node2D

# Create signals to update GUI
signal update_score
signal update_next_block
signal gameover

# States of game
enum States { STOP, PLAY, PAUSE }

# Declare member const here.
const FAST_DOWN_SPEED = 20
const FAST_DOWN_POINT = 5

# Declare member variables here.

# Block scenes
var block_list = [
    preload("res://blocks/S.tscn"),
    preload("res://blocks/L.tscn"),
    preload("res://blocks/J.tscn"),
    preload("res://blocks/T.tscn"),
    preload("res://blocks/Z.tscn"),
    preload("res://blocks/O.tscn"),
    preload("res://blocks/I.tscn"),
]

# Positions list
var position_cursor = {}

const START_POSITION = StoreSettings.TILE_SIZE / 2
const FINAL_POSITION = START_POSITION + StoreSettings.TILE_SIZE * 20

var tile_scene = preload("res://blocks/Tile.tscn")

# Keeps track of the current state
var _state = States.STOP

# Keeps track of fast down enable
var _fast_down = false

# player block node
var player_block
var next_block

# Vector to move down
var velocity_down

# Player score
var _score = 0
var _completed_lines = 0

# Called when the node enters the scene tree for the first time.
func _ready():
    # Setups a time-based seed to generator.
    randomize()
    _game_start()


func _game_start():

    # Initializa position cursor
    position_cursor = {}

    for i in range(START_POSITION, FINAL_POSITION, StoreSettings.TILE_SIZE):
        position_cursor[i] = []

    # Reset score
    _update_score(0, 0)
    _fast_down = false

    # Instance vector
    velocity_down = Vector2(0, 1).normalized() * StoreSettings.TILE_SIZE

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

    if Input.is_action_just_pressed("ui_left"):
        velocity.x -= 1

    elif Input.is_action_just_pressed("ui_right"):
        velocity.x += 1

    elif Input.is_action_pressed("ui_down"):
        velocity.y += 1
        _fast_down = true

    elif Input.is_action_just_released("ui_down"):
        _fast_down = false

    # Increase down speed of player block
    if _fast_down and velocity.y > 0:
        player_block.move_and_collide(velocity_down)

    elif velocity.length() > 0:
        velocity = velocity.normalized() * StoreSettings.TILE_SIZE
        player_block.move_and_collide(velocity)

    if Input.is_action_just_pressed("ui_up"):

        # Rotate block and check collision rotate
        player_block.rotate_block()


func _get_player_block():

    if player_block:
        remove_child(player_block)
        player_block.add_to_group('Junk')

    # Instance player block
    if next_block:
        player_block = next_block
    else:
        player_block = get_next_block()

    # Create next block and send it to show in GUI
    next_block = get_next_block()
    emit_signal("update_next_block", next_block)

    # Add player to board tree
    add_child(player_block)
    player_block.position = $StartPosition.position

    if player_block.get_name() == 'I' or player_block.get_name() == 'O':
        player_block.adjust_position()

func get_next_block():
    return block_list[randi() % block_list.size()].instance()

func _clear_line():

    # store complete line index from list
    var completed_line_index_list = []

    for i in position_cursor:

        # List is complete (10 blocks)
        if position_cursor[i].size() == 10:

            # Delete shapes in list
            for tile in position_cursor[i]:
                remove_child(tile)
                tile.remove_from_group("StuckBlocks")
                tile.add_to_group("Junk")

            # Clear the list
            position_cursor[i].clear()

            # Store the index of clear line
            completed_line_index_list.append(i)

    # Move the tile _completed_lines down and above
    for idx in completed_line_index_list:

        for pos in range(idx, START_POSITION, -StoreSettings.TILE_SIZE):

            for tile in position_cursor[pos]:
                tile.position += velocity_down

                # Update the next tile position
                position_cursor[int(tile.position.y)].append(tile)

            # Clear the currente position list
            position_cursor[pos].clear()

    if completed_line_index_list.size():
        var score_value = _score + 100 * pow(2, completed_line_index_list.size() - 1)
        var line_count = _completed_lines + completed_line_index_list.size()
        _update_score(score_value, line_count)

        if StoreSettings.audio_sfx:
            $CleanLineSFX.play()

func _update_score(score_value, lines_count):
    # Update _score and line on GUI
    _score = score_value
    _completed_lines = lines_count
    emit_signal("update_score", _score, _completed_lines)

func _on_FallingTimer_timeout():

    if _state != States.PLAY:
        return

    var collision_info

    if not _fast_down:
        collision_info = player_block.move_and_collide(velocity_down)
    else:
        collision_info = false

    if collision_info:

        if _fast_down:
            _fast_down = false
            _update_score(_score + FAST_DOWN_POINT, _completed_lines)

        # Save current player block to group
        for tile in player_block.get_children():

            # Create tile and insert it in scene tree
            var tile_body = tile_scene.instance()

            tile_body.get_node("Sprite").modulate = tile.get_node("Sprite").modulate
            tile_body.position = tile.position + player_block.position
            add_child(tile_body)

            if position_cursor.has(int(tile_body.position.y)):
                position_cursor[int(tile_body.position.y)].append(tile_body)

        # Generate a new block to player
        _get_player_block()

        # Check complete lines and clean then
        _clear_line()

func _on_Roof_body_entered(body):
    _state = States.STOP
    emit_signal("gameover")

    if StoreSettings.audio_music:
        $BackgroundMusic.stop()

    if StoreSettings.audio_sfx:
        $GameOverSFX.play()


func _on_GUI_change_game_state():

    if _state == States.PLAY:
        _state = States.PAUSE
        $FallingTimer.stop()

    elif _state == States.PAUSE:
        _state = States.PLAY
        $FallingTimer.start()


func _on_GUI_restart_game():

    for pos in $PositionCursor.get_children():
        pos.clear_tile_list()

    get_tree().call_group("StuckBlocks", "queue_free")
    get_tree().call_group("Junk", "queue_free")

    if player_block:
        remove_child(player_block)
        player_block.queue_free()

    _game_start()

