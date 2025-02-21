class_name  CollectibleManager
extends Node

@export var player: Player
@export var score_timer: Timer

var currentCoins = 0
var score = 0
var hiScore: int = 0


func _ready() -> void:
	SignalManager.passColectible.connect(onCollectible)

func set_coins(coins) -> void:
	currentCoins = coins

func add_coins(coinsToAdd) -> void:
	currentCoins += coinsToAdd
	
func get_coins() -> int:
	return currentCoins
	
#This functions returns the current player score
func getScore() -> int:
	return score
	
func setScore(currScore: int) -> void:
	score = currScore
	
func addScore(scoreToAdd: int) -> void:
	score += scoreToAdd
	
#Returns High Score
func getHighScore() -> int:
	return hiScore
	
#This function changes the high score	
func findAndSetHighScore() -> void:
	if(score > hiScore):
		hiScore = score

func setHighScore(newScore: int) -> void:
	hiScore = newScore

func onCollectible(collectible: Collectible) -> void:
	if collectible.type == CollectibleType.Type.coin:
		add_coins(1)
		addScore(collectible.get_points())
	else:
		addScore(collectible.get_points())
		
# This is used to count score
func _on_score_timer_timeout() -> void:
	if (player._isPlayerAlive()):
		score+=1
		
func startScoreTimer() -> void:
	score_timer.start()
