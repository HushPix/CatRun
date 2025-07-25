extends Node

var passFile: String = "ski1011bid102137amo2gusGy4ttOb4ma12232003"
var saveData: Dictionary
const PATH = "user://" # change res to user before building

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
	
func saveFile() -> void:
	saveData.clear()
	
	#var file: FileAccess = FileAccess.open_encrypted_with_pass(PATH, FileAccess.WRITE, passFile)
	var file: FileAccess = FileAccess.open(PATH + "catInf.sav", FileAccess.WRITE)
	SignalManager.saveData.emit()
	
	var json_data = JSON.stringify(saveData)
	file.store_line(json_data)
	
	file.close()


func loadFile() -> void:
	if not FileAccess.file_exists(PATH + "catInf.sav"):
		return
		
	saveData.clear()
	var file: FileAccess = FileAccess.open(PATH + "catInf.sav", FileAccess.READ)
	
	while file.get_position() < file.get_length():
		var json_string = file.get_line()
		var json = JSON.new()
		
		var parseResult = json.parse(json_string)
		if not parseResult == OK:
			print("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())
			continue
		saveData = json.data
	#print(saveData)
	SignalManager.loadData.emit()

#This function is used to modify the savedata (will change name to something more expansive)
#func saveFile() -> void:
	#var file: FileAccess = FileAccess.open_encrypted_with_pass(PATH, FileAccess.WRITE, passFile)
	#SignalManager.emit_signal("saveCollectibles")
	#deleteSave()
	#
	#for i in saveData.data.size():
		#var line: String = str(saveData.data.keys()[i], ":", saveData.data.values()[i], "\r").replace(" ", "")
		#file.store_line(line)
	##file.store_string(JSON.stringify(saveData.data)) # zapis w jendej lini, ale niezbyt bezpieczny
	#file.close()

#This is used to load in the saveData
#func loadFile() -> void:
	#if FileAccess.file_exists(PATH):
		#var file = FileAccess.open_encrypted_with_pass(PATH, FileAccess.READ, passFile)
		##saveData.data =JSON.parse_string(file.get_as_text()) # json w jednej linii, ale mam wrazenie ze niebezpieczny	
		#for i in file.get_as_text().count(":"):
			#var line = file.get_line()
			#var key = line.split(":")[0]
			#var value = line.split(":")[1]
			#if value.is_valid_int():
				#value = int(value)
			#elif value.is_valid_float():
				#value = float(value)
			#elif value.begins_with("["):
				#value = value.trim_prefix("[")
				#value = value.trim_suffix("]")
				#value = value.split(",")
			#saveData.data[key] = value
		#
		#file.close()
		#debugFile()
		#SignalManager.emit_signal("loadCollectibles")
		

#This is a quick way to reset the save data		
func deleteSave() -> void:
	DirAccess.remove_absolute(PATH) 

func debugFile() -> void:
	#for i in saveData.data:
		#print(saveData.data[i])
	print("loaded")
