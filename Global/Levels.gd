extends Node
var SAVE_FILE =  ProjectSettings.globalize_path("user://Save/savefile.save")

var Firsttime = true
var Level1 = false
var Level2 = false
var Cutscene1 = false
var Level3 = false
var Level4 = false
var Level5 = false
var Level6 = false
var Level7 = false


func save():
	
	DirAccess.make_dir_absolute("user://Save/")
	var file = FileAccess.open(SAVE_FILE, FileAccess.WRITE)
	
	file.store_var(Firsttime)
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
		
		Firsttime = file.get_var(Firsttime)
		Level1 = file.get_var(Level1)
		Level2 = file.get_var(Level2)
		Level3 = file.get_var(Level3)
		Level4 = file.get_var(Level4)
		Level5 = file.get_var(Level5)
		Level6 = file.get_var(Level6)
	else:
		print("No data saved...")
		
		Firsttime = true
		Level1 = false
		Level2 = false
		Level3 = false
		Level4 = false
		Level5 = false
		Level6 = false
		Level7 = false
