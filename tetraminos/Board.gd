extends Node

const TILE_SIZE = 32

# Called when the node enters the scene tree for the first time.
func _ready():
    pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
# warning-ignore:unused_argument
func _process(delta):

    var velocity = Vector2()

    if Input.is_action_just_pressed("ui_up"):
        $Player.rotate_block()

    elif Input.is_action_just_pressed("ui_left"):
        velocity.x -= 1

    elif Input.is_action_just_pressed("ui_right"):
        velocity.x += 1

    elif Input.is_action_just_pressed("ui_down"):
        velocity.y += 1

    if velocity.length() > 0:
        velocity = velocity.normalized() * TILE_SIZE

    $Player.move_and_collide(velocity)
