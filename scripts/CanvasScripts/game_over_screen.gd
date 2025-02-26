extends Canvas_Menu

@export var gameOverLabel: Label
@export var scoreLabelGameOver: Label
@export var retryButton: AudioButton
@export var collectibleManager: CollectibleManager

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_score_label_2_visibility_changed() -> void:
	_updateScore(scoreLabelGameOver, false, collectibleManager)
