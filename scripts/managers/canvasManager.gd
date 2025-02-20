class_name CanvasManager
extends CanvasLayer



@export var player: Player
@export var gameplay: Gameplay 
@export var collectibleManager: CollectibleManager
@export var gameplayHud: Canvas_Menu
@export var mainMenu: Canvas_Menu
@export var pauseMenu: Canvas_Menu
@export var gameOverMenu: Canvas_Menu

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player.playerDied.connect(on_game_over)
	pause_menu.hide()
#


## Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if player._isPlayerAlive():
		_updateScore(score_label, false)

## Hides the main menu and shows hud, when player starts the game
#func _on_start_button_pressed() -> void: ## When player is ready
	#main_menu.hide()
	#gameplay_hud.show()
	#_updateScore(hi_score_label, true)
	#
#
## This happens when the player enters the scene
#func _on_gameplay_ready() -> void: ## When the scene starts
	#_updateScore(hi_score_label_menu, true)
	#main_menu.show()
	#gameplay_hud.hide()
	#
#func on_game_over() -> void:
	#gameplay_hud.hide()
	#_updateScore(score_label_2, false)
	#game_over_screen.show()
#
#
#func _on_pause_button_pressed() -> void:
	#pause_menu.show()
#
#
#func _on_un_pause_button_pressed() -> void:
	#pause_menu.hide()

#func _unhandled_input(event: InputEvent) -> void:
	#if event.is_action_pressed("uiButtonAccept"):
		#if main_menu.visible:
			#start_button.emit_signal("pressed")



func _on_start_button_pressed() -> void:
	mainMenu.hide()
	gameplayHud.show()


func _on_pause_button_pressed() -> void:
	gameplayHud.hide()

func _on_un_pause_button_pressed() -> void:
	gameplayHud.show()
