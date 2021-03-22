extends KinematicBody2D

# Declare member const here.
const ANGLE = PI/2

func rotate_block():

    if not _check_collision_on_rotate():

        # Rotate tiles shapes.Change (x, y) by (-y, x) to rotate
        $Shape_01.position = Vector2($Shape_01.position.y * -1, $Shape_01.position.x)
        $Shape_02.position = Vector2($Shape_02.position.y * -1, $Shape_02.position.x)
        $Shape_03.position = Vector2($Shape_03.position.y * -1, $Shape_03.position.x)
        $Shape_04.position = Vector2($Shape_04.position.y * -1, $Shape_04.position.x)

        # Rotete de RayCast2D
        $Shape_01/RayCast2D.position = Vector2($Shape_01/RayCast2D.position.y * -1, $Shape_01/RayCast2D.position.x)
        $Shape_02/RayCast2D.position = Vector2($Shape_02/RayCast2D.position.y * -1, $Shape_02/RayCast2D.position.x)
        $Shape_03/RayCast2D.position = Vector2($Shape_03/RayCast2D.position.y * -1, $Shape_03/RayCast2D.position.x)

        $Shape_02/RayCast2D.cast_to = Vector2($Shape_02/RayCast2D.cast_to.y * -1, $Shape_02/RayCast2D.cast_to.x)
        $Shape_03/RayCast2D.cast_to = Vector2($Shape_03/RayCast2D.cast_to.y * -1, $Shape_03/RayCast2D.cast_to.x)
        $Shape_01/RayCast2D.cast_to = Vector2($Shape_01/RayCast2D.cast_to.y * -1, $Shape_01/RayCast2D.cast_to.x)

func _check_collision_on_rotate():
    var transform2d = Transform2D(rotation + ANGLE, position)
    return $Shape_02/RayCast2D.is_colliding() or $Shape_03/RayCast2D.is_colliding() or $Shape_01/RayCast2D.is_colliding() or test_move(transform2d, Vector2(0, 0), false)

