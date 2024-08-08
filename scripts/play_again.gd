extends Button


# Called when the node enters the scene tree for the first time.
func _pressed():
	get_tree().change_scene_to_file("res://scenes/node_2d.tscn")
