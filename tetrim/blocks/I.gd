extends KinematicBody2D

# Declare member const here.
const ANGLE = PI/2

func adjust_position():
    position.x -= StoreSettings.TILE_SIZE / 2

func rotate_block():

    if not _check_collision_on_rotate():

        var raycast: RayCast2D

        # Rotate tiles shapes.Change (x, y) by (-y, x) to rotate
        for shape in get_children():
            shape.position = Vector2(shape.position.y * -1, shape.position.x)

            raycast = shape.get_node('RayCast2D')

            # Rotate raycast of shape
            raycast.position = Vector2(raycast.position.y * -1, raycast.position.x)
            raycast.cast_to = Vector2(raycast.cast_to.y * -1, raycast.cast_to.x)

        adjust_position()

func _check_collision_on_rotate():

    var _collision = false

    for shape in get_children():
        _collision = _collision or shape.get_node('RayCast2D').is_colliding()

    return _collision
