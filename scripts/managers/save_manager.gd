extends Node

var saveData: SaveData = SaveData.new()
var passFile: String = "ski1011bid102137amo2gusGy4ttOb4ma12232003"

const PATH = "res://cat_run_save.sav" # change res to user before building

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
#This function is used to modify the savedata (will change name to something more expansive)
func saveFile() -> void:
	var file: FileAccess = FileAccess.open_encrypted_with_pass(PATH, FileAccess.WRITE, passFile)
	SignalManager.emit_signal("saveCollectibles")
	deleteSave()
	
	for i in saveData.data.size():
		var line: String = str(saveData.data.keys()[i], ":", saveData.data.values()[i], "\r").replace(" ", "")
		file.store_line(line)
	#file.store_string(JSON.stringify(saveData.data)) # zapis w jendej lini, ale niezbyt bezpieczny
	file.close()

#This is used to load in the saveData
func loadFile() -> void:
	if FileAccess.file_exists(PATH):
		var file = FileAccess.open_encrypted_with_pass(PATH, FileAccess.READ, passFile)
		#saveData.data =JSON.parse_string(file.get_as_text()) # json w jednej linii, ale mam wrazenie ze niebezpieczny	
		for i in file.get_as_text().count(":"):
			var line = file.get_line()
			var key = line.split(":")[0]
			var value = line.split(":")[1]
			if value.is_valid_int():
				value = int(value)
			elif value.is_valid_float():
				value = float(value)
			elif value.begins_with("["):
				value = value.trim_prefix("[")
				value = value.trim_suffix("]")
				value = value.split(",")
			saveData.data[key] = value
		
		file.close()
		SignalManager.emit_signal("loadCollectibles")
		debugFile()

#This is a quick way to reset the save data		
func deleteSave() -> void:
	DirAccess.remove_absolute(PATH) 

func debugFile() -> void:
	for i in saveData.data:
		print(saveData.data[i])
