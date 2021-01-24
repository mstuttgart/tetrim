extends Node2D

var lista = []
var count = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	lista.append(get_node("Position_1"))
	lista.append(get_node("Position_2"))
	lista.append(get_node("Position_3"))
	lista.append(get_node("Position_4"))

func get_current_block():
	return lista[count]

func rotate_block():
	# Torna o block anterior invisivel
	lista[count].visible = false

	count = (count + 1) if count < 3 else 0

	lista[count].visible = true


