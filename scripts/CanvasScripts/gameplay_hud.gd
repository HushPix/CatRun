extends Canvas_Menu

@export var scoreLabel: Label 
@export var hiScoreLabel: Label
#@export var pauseButton: AudioButton
@export var collectibleManager: CollectibleManager
@export var coinIcon: TextureRect
@export var coinAmountLabel: Label

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalManager.passColectible.connect(_updateCoins)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if self.visible:
		_updateScore(scoreLabel, false, collectibleManager)

func _on_visibility_changed() -> void:
	_updateScore(hiScoreLabel, true, collectibleManager)
	_displayNumsWithEquals(coinAmountLabel, collectibleManager.get_coins())
	print(collectibleManager.get_coins())


func _updateCoins(collectible: Collectible) -> void:
	_displayNumsWithEquals(coinAmountLabel, collectibleManager.get_coins())
	print(collectibleManager.get_coins())
