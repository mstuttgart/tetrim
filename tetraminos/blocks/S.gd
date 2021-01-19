extends Node2D

var lista = [$TileMap, $TileMap2, $TileMap3, $TileMap4]
var count = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):

	if Input.is_action_just_pressed("ui_right"):

		# Torna a posiçao anterior invisivel
		lista[count].visible = false
		count = (count + 1) if count < 3 else 0

		lista[count].visible = true



