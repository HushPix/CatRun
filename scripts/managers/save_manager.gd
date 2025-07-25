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



#This is a quick way to reset the save data		
func deleteSave() -> void:
	DirAccess.remove_absolute(PATH + "catInf.sav") 

func debugFile() -> void:
	#for i in saveData.data:
		#print(saveData.data[i])
	print("loaded")
