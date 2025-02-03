extends CanvasLayer


@onready var player: Player = $"../Player"
@onready var gameplay: Node2D = $".."
@onready var main_menu: Control = $MainMenu
@onready var gameplay_hud: Control = $GameplayHud
@onready var score_label: Label = $GameplayHud/scoreLabel
@onready var pause_menu: Control = $PauseMenu
@onready var game_over_screen: Control = $gameOverScreen
@onready var score_label_2: Label = $gameOverScreen/scoreLabel2
@onready var hi_score_label: Label = $GameplayHud/hiScoreLabel


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player.playerDied.connect(on_game_over)
	pause_menu.hide()

func _updateScore(label: Label, isHiScore: bool) -> void: #updates the score every frame
	if(isHiScore):
		label.text = "BEST:" + str(gameplay.getHighScore())
	else:
		label.text = str(gameplay.getScore())

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	_updateScore(score_label, false)

# Hides the main menu and shows hud, when player starts the game
func _on_start_button_pressed() -> void: ## When player is ready
	main_menu.hide()
	gameplay_hud.show()
	_updateScore(hi_score_label, true)
	

# This happens when the player enters the scene
func _on_gameplay_ready() -> void: ## When the scene starts
	main_menu.show()
	gameplay_hud.hide()
	
func on_game_over() -> void:
	gameplay_hud.hide()
	_updateScore(score_label_2, false)
	game_over_screen.show()


func _on_pause_button_pressed() -> void:
	pause_menu.show()


func _on_un_pause_button_pressed() -> void:
	pause_menu.hide()
