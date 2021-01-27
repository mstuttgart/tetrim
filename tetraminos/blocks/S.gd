extends KinematicBody2D

func rotate_block():

	if not check_collision_on_rotate():
		rotation += PI/2

func check_collision_on_rotate():
	var transform2d = Transform2D(rotation + PI/2, position)
	return $RayCast2D_1.is_colliding() or $RayCast2D_2.is_colliding() or test_move(transform2d, Vector2(0, 0), false)

