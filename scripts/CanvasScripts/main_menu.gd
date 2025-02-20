extends Canvas_Menu

@export var startButton: AudioButton

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_showMenu(self)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("uiButtonAccept"):
		if visible:
			startButton.emit_signal("pressed")
