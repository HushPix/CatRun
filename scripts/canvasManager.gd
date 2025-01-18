extends CanvasLayer

@onready var gameplay: Node2D = $".."
@onready var main_menu: Control = $MainMenu
@onready var gameplay_hud: Control = $GameplayHud
@onready var score_label: Label = $GameplayHud/scoreLabel
@onready var pause_menu: Control = $PauseMenu


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pause_menu.hide()

func _updateScore() -> void: #updates the score every frame
	score_label.text = str(gameplay.getScore())

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	_updateScore()

# Hides the main menu and shows hud, when player starts the game
func _on_start_button_pressed() -> void: ## When player is ready
	main_menu.hide()
	gameplay_hud.show()
	

# This happens when the player enters the scene
func _on_gameplay_ready() -> void: ## When the scene starts
	main_menu.show()
	gameplay_hud.hide()


func _on_pause_button_pressed() -> void:
	pause_menu.show()


func _on_un_pause_button_pressed() -> void:
	pause_menu.hide()
