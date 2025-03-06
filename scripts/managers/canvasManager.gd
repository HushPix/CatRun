class_name CanvasManager
extends CanvasLayer



@export var player: Player
@export var gameplay: Gameplay 
@export var collectibleManager: CollectibleManager
@export var gameplayHud: Canvas_Menu
@export var mainMenu: Canvas_Menu
@export var pauseMenu: Canvas_Menu
@export var gameOverMenu: Canvas_Menu
@export var countDownMenu: Canvas_Menu

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player.playerDied.connect(on_game_over)
	mainMenu.show()
	
func on_game_over() -> void:
	gameplayHud.hide()
	gameOverMenu.show()

#func _unhandled_input(event: InputEvent) -> void:
	#if event.is_action_pressed("uiButtonAccept"):
		#if main_menu.visible:
			#start_button.emit_signal("pressed")

func _on_start_button_pressed() -> void:
	mainMenu.hide()
	countDownMenu.show()
	await gameplay.begin_countdown(gameplay.countDownTime)
	countDownMenu.hide()
	gameplayHud.show()


func _on_pause_button_pressed() -> void:
	gameplayHud.hide()
	pauseMenu.show()

func _on_un_pause_button_pressed() -> void:
	pauseMenu.hide()
	gameplayHud.show()
