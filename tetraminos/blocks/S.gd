extends KinematicBody2D

# Declare member const here.
const ANGLE = PI/2

func rotate_block():

    if not _check_collision_on_rotate():

        # Rotate tiles shapes.Change (x, y) by (-y, x) to rotate
        $Tile1_Shape.position = Vector2($Tile1_Shape.position.y * -1, $Tile1_Shape.position.x)
        $Tile2_Shape.position = Vector2($Tile2_Shape.position.y * -1, $Tile2_Shape.position.x)
        $Tile3_Shape.position = Vector2($Tile3_Shape.position.y * -1, $Tile3_Shape.position.x)
        $Tile4_Shape.position = Vector2($Tile4_Shape.position.y * -1, $Tile4_Shape.position.x)

        # Rotete de RayCast2D
        $Tile2_Shape/RayCast2D_1.position = Vector2($Tile2_Shape/RayCast2D_1.position.y * -1, $Tile2_Shape/RayCast2D_1.position.x)
        $Tile3_Shape/RayCast2D_2.position = Vector2($Tile3_Shape/RayCast2D_2.position.y * -1, $Tile3_Shape/RayCast2D_2.position.x)

        $Tile2_Shape/RayCast2D_1.cast_to = Vector2($Tile2_Shape/RayCast2D_1.cast_to.y * -1, $Tile2_Shape/RayCast2D_1.cast_to.x)
        $Tile3_Shape/RayCast2D_2.cast_to = Vector2($Tile3_Shape/RayCast2D_2.cast_to.y * -1, $Tile3_Shape/RayCast2D_2.cast_to.x)

func _check_collision_on_rotate():
    var transform2d = Transform2D(rotation + ANGLE, position)
    return $Tile2_Shape/RayCast2D_1.is_colliding() or $Tile3_Shape/RayCast2D_2.is_colliding() or test_move(transform2d, Vector2(0, 0), false)

