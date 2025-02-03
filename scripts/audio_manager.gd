extends Node2D
class_name AudioManager

@export var audioListener: AudioListener2D
@export var musicPlayer: AudioStreamPlayer

const SOUND_gameOver = preload("res://sfx/fail.wav")

func _ready() -> void:
	pass
	
func _process(delta: float) -> void:
	pass
	
func gameOverAudio() -> void:
	musicPlayer.stream = SOUND_gameOver
	musicPlayer.play()
	
	
