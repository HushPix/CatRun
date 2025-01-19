extends Node2D
@onready var gameplayNode = get_parent()

@onready var ground_bg: Parallax2D = $groundBG
@onready var clouds_bg: Parallax2D = $cloudsBG
@onready var sky_bg: Parallax2D = $skyBG

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	ground_bg.autoscroll.x = gameplayNode.getSpeed() * -50
	clouds_bg.autoscroll.x = gameplayNode.getSpeed() * -20
	sky_bg.autoscroll.x = gameplayNode.getSpeed() * -10
	
