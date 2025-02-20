class_name SaveManager
extends Node

const SAVEFILE = "res://cat_run_save.sav" # change res to user before building
@export var collectibleManager: CollectibleManager

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
#This function is used to modify the savedata (will change name to something more expansive)
func save_score() -> void:
	var file = FileAccess.open(SAVEFILE, FileAccess.WRITE_READ)
	file.store_64(collectibleManager.getHighScore())

#This is used to load in the saveData
func load_score() -> void:
	var file = FileAccess.open(SAVEFILE, FileAccess.READ)
	if(FileAccess.file_exists(SAVEFILE)):
		collectibleManager.setHighScore(file.get_64())
		
#This is a quick way to reset the save data		
func delete_save() -> void:
	collectibleManager.setHighScore(0)
	collectibleManager.setScore(0)
	save_score()
