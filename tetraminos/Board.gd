extends Node

const TILE_SIZE = 32
var angle = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
# warning-ignore:unused_argument
func _process(delta):

	var velocity = Vector2()

	if Input.is_action_just_pressed("ui_up"):

		var transform2d = Transform2D(angle + PI/2, $S.position)

		# Realizamos a rotaçao com 90 de modo a verificar
		# se nao ocorre colisao com outros blocos e com a
		# borda do tabuleiro. Caso nao ocorra colisao, realizamos
		# a rotacao
		if not $S.test_move(transform2d, Vector2(0, 0), false):
			angle += PI/2
			$S.rotation = angle
		else:
			print("collision!!!")

	elif Input.is_action_just_pressed("ui_left"):
		velocity.x -= 1

	elif Input.is_action_just_pressed("ui_right"):
		velocity.x += 1

	elif Input.is_action_just_pressed("ui_down"):
		velocity.y += 1

	if velocity.length() > 0:
		velocity = velocity.normalized() * TILE_SIZE

	$S.move_and_collide(velocity)
