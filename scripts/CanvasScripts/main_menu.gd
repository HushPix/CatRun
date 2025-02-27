extends Canvas_Menu

@export var startButton: AudioButton
@export var highScoreLabelMenu: Label
@export var collectibleManager: CollectibleManager

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("uiButtonAccept"):
		if visible:
			startButton.emit_signal("pressed")

func _on_hi_score_label_menu_draw() -> void:
	_updateScore(highScoreLabelMenu, true, collectibleManager)
