extends Button
class_name AudioButton

@export var pressSound: AudioStreamWAV
@export var buttonText: String = " "
@export var buttonAudioPlayer: AudioStreamPlayer
@export var textStyle: LabelSettings
@export var textOffset: Vector2

# Called when the node enters the scene tree for the first time.
func _init() -> void:
	if textStyle == null:
		textStyle = load("res://LabelSettings/pixelTextoutline.tres")

		
func _ready() -> void:
	pass


func _on_pressed() -> void:
	buttonAudioPlayer.stream = pressSound
	buttonAudioPlayer.play()
