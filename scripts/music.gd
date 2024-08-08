extends AudioStreamPlayer2D


var song_pos = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func play_on_pos():
	play(song_pos)
	
func _on_finished():
	play()
