extends Node

const TILE_SIZE = 32

# This flag set blocks to fall
var time_to_fall = false
var stop_block = 0

var block_list = [
    preload("res://blocks/S.tscn"),
]

var player_block = KinematicBody2D

# Called when the node enters the scene tree for the first time.
func _ready():
    # Setups a time-based seed to generator.
    randomize()

    # Start timer of falling block
    $FallingTimer.start()

    # Load player block
    _get_player_block()


# Called every frame. 'delta' is the elapsed time since the previous frame.
# warning-ignore:unused_argument
func _process(delta):

    var velocity = Vector2()

    if Input.is_action_just_pressed("ui_up"):

        # Rotate block and check collision rotate
        player_block.rotate_block()

    elif Input.is_action_just_pressed("ui_left"):
        velocity.x -= 1

    elif Input.is_action_just_pressed("ui_right"):
        velocity.x += 1

    elif Input.is_action_just_pressed("ui_down") or time_to_fall:
        velocity.y += 1

        # Reset fall flag
        time_to_fall = false

        var transform2d = Transform2D(player_block.rotation, player_block.position)

        if player_block.test_move(transform2d, Vector2(0, TILE_SIZE), false) and stop_block != 2:
            stop_block += 1

        if stop_block == 2:
            # Block no can fall
            stop_block = 0

            # Save current player block to group
            player_block.add_to_group('stuck_blocks')

            # Generate a new block to player
            _get_player_block()
            return

    if velocity.length() > 0:
        velocity = velocity.normalized() * TILE_SIZE

    # Check collision and move block
    player_block.move_and_collide(velocity)


func _get_player_block():

    var idx = rand_range(0, block_list.size() - 1)

    # Instanciamos o player
    player_block = block_list[idx].instance()
    player_block.position = $StartPosition.position

    # Adicionamos o player a tree principal
    add_child(player_block)


func _on_FallingTimer_timeout():
    time_to_fall = true
