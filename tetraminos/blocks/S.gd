extends KinematicBody2D

const ANGLE = PI/2

func rotate_block():

    if not _check_collision_on_rotate():
        rotation += ANGLE

func _check_collision_on_rotate():
    var transform2d = Transform2D(rotation + ANGLE, position)
    return $RayCast2D_1.is_colliding() or $RayCast2D_2.is_colliding() or test_move(transform2d, Vector2(0, 0), false)
