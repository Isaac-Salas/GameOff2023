extends Node
const SAVE_FILE = "res://Saves/save_file.save"
var g_data = {}

var Level1 = true
var Level2 = false
var Level3 = false
var Level4 = false
var Level5 = false
var Level6 = false
var Level7 = false

func save():
	var file = FileAccess.open(SAVE_FILE, FileAccess.WRITE)
	file.store_var(Level1)
	file.store_var(Level2)
	file.store_var(Level3)
	file.store_var(Level4)
	file.store_var(Level5)
	file.store_var(Level6)
	file.store_var(Level7)

func load_data():
	if FileAccess.file_exists(SAVE_FILE):
		var file = FileAccess.open(SAVE_FILE, FileAccess.READ)
