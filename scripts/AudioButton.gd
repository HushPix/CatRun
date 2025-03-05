extends Button
class_name AudioButton

@export var pressSound: AudioStreamWAV
@export var buttonText: String = " "
@export var buttonAudioPlayer: AudioStreamPlayer
@onready var buttonLabel: Label = $ButtonText
@export var textStyle: LabelSettings
@export var textOffset: Vector2

# Called when the node enters the scene tree for the first time.
func _init() -> void:
	if textStyle == null:
		textStyle = load("res://LabelSettings/pixelTextoutline.tres")

		
func _ready() -> void:
	if buttonLabel != null:
		buttonLabel.text = buttonText
		buttonLabel.label_settings = textStyle
		buttonLabel.set_position(buttonLabel.position + textOffset)


func _on_pressed() -> void:
	buttonAudioPlayer.stream = pressSound
	buttonAudioPlayer.play()
