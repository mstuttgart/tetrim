extends KinematicBody2D

# Declare member const here.
const ANGLE = PI/2

func rotate_block():

    if not _check_collision_on_rotate():

        var raycast: RayCast2D

        # Rotate tiles shapes.Change (x, y) by (-y, x) to rotate
        for shape in get_children():
            shape.position = Vector2(shape.position.y * -1, shape.position.x)

            # Rotate raycast of shape
            if shape.has_node('RayCast2D'):
                raycast = shape.get_node('RayCast2D')

                raycast.position = Vector2(raycast.position.y * -1, raycast.position.x)
                raycast.cast_to = Vector2(raycast.cast_to.y * -1, raycast.cast_to.x)


func _check_collision_on_rotate():

    var _collision = false

    for shape in get_children():

        if shape.has_node('RayCast2D'):
            _collision = _collision or shape.get_node('RayCast2D').is_colliding()

    return _collision
