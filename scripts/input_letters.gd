extends Node2D

var columns = [[], [], [], [], []]
var letters = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]
var letterBox = {} # The letter sprites, the "letters" array will be to find the index

var row = 0
var column = 0
var chars = {
 'A': KEY_A, 'B': KEY_B, 'C': KEY_C, 'D': KEY_D, 'E': KEY_E,
 'F': KEY_F, 'G': KEY_G, 'H': KEY_H, 'I': KEY_I, 'J': KEY_J,
 'K': KEY_K, 'L': KEY_L, 'M': KEY_M, 'N': KEY_N, 'O': KEY_O,
 'P': KEY_P, 'Q': KEY_Q, 'R': KEY_R, 'S': KEY_S, 'T': KEY_T,
 'U': KEY_U, 'V': KEY_V, 'W': KEY_W, 'X': KEY_X, 'Y': KEY_Y, 'Z': KEY_Z,
 'ENTER': KEY_ENTER, 'BACKSPACE': KEY_BACKSPACE
}

# Colors of boxes
var gray
var yellow
var green


var word
var rng = RandomNumberGenerator.new()

func get_word():
	var file = FileAccess.open("res://scripts/words.json", FileAccess.READ)
	var data =  JSON.parse_string(file.get_as_text())
	var index = rng.randi_range(0, len(data)) # Get random word from index
	word = data[index]
	print(word)
	Word.word = word
	
# Get row nodes
func _ready():
	get_word()
	gray = preload("res://textures/box_gray.tres")
	green = preload("res://textures/box_green.tres")
	yellow = preload("res://textures/box_yellow.tres")
	
	for i in range(len(letters)):
		letterBox[letters[i]] = get_node("Letters/"+str(i))
		
	for i in range(5):
		for j in range(5):
			if j == 0:
				columns[i].push_back(get_node("Row " + str(i + 1) + "/BoxEmpty")) # Gets the "BoxEmpty" sprite, which contains the texture, and the child textbox
			else:
				columns[i].push_back(get_node("Row " + str(i + 1) + "/BoxEmpty" + str(j + 1))) # Starts at "BoxEmpty2" not "BoxEmpty0", weird


func check_true():
	var correct = 0
	for i in range(5):
		var box = columns[row][i]
		var text_box = box.get_node("RichTextLabel")
		var letter = text_box.text[8].to_lower()
		if letter == word[i]: # Correct letter in correct pos
			box.texture = green
			letterBox[letter.to_upper()].texture = green
			correct+=1
		elif letter in word: # Correct letter in incorrect pos
			box.texture = yellow
			letterBox[letter.to_upper()].texture = yellow
		else: # Incorrect letter
			box.texture = gray
			letterBox[letter.to_upper()].texture = gray
	
	if correct == 5:
		get_tree().change_scene_to_file("res://scenes/win screen.tscn")
	elif row == 4:
		get_tree().change_scene_to_file("res://scenes/lose screen.tscn")
		

func _unhandled_key_input(input_event: InputEvent) -> void:
	if input_event is InputEventKey:
		if input_event.pressed and input_event.keycode in chars.values():
			var text_box;
			
			if column > 5: # Just to check if somehow the code leads to a column increasing out of bounds
				column = 4
			
			if input_event.keycode == KEY_BACKSPACE:
				text_box = columns[row][column].get_node("RichTextLabel")
				
				if text_box.text == "[center]":
					if column != 0:
						text_box = columns[row][column - 1].get_node("RichTextLabel")
						text_box.text = "[center]"
						column-=1
				else:
					text_box.text = "[center]"
				
			elif input_event.keycode == KEY_ENTER:
				text_box = columns[row][column].get_node("RichTextLabel")
				if column != 4:
					pass
				elif text_box.text != "[center]":
					check_true()
					row += 1
					column = 0
			elif column <= 4:
				text_box = columns[row][column].get_node("RichTextLabel")
				if column == 4 and text_box.text != "[center]":
					pass
				else:
					text_box.text = "[center]" + input_event.as_text_keycode()
					if column != 4:
						column+=1
			
