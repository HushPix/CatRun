extends Canvas_Menu

@export var scoreLabel: Label 
@export var hiScoreLabel: Label
@export var pauseButton: AudioButton
@export var collectibleManager: CollectibleManager

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_hideMenu(self)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _updateScore(label: Label, isHiScore: bool) -> void: #updates the score every frame
	if(isHiScore):
		label.text = "BEST:" + str(collectibleManager.getHighScore())
	else:
		label.text = str(collectibleManager.getScore())
