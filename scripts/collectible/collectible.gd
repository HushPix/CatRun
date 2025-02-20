class_name Collectible extends Node2D

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var area_2d: Area2D = $Area2D
@onready var collectible_audio: AudioStreamPlayer = $collectibleAudio

@export var data: CollectibleData

var type: CollectibleType.Type
var points: int

func setCollectibleData(data: CollectibleData):
	sprite_2d.texture = data.sprite
	collectible_audio.stream = data.sound
	points = data.points
	type = data.type

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	setCollectibleData(data)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func get_type() -> CollectibleType.Type:
	return type
	
func get_points() -> int:
	return points

func _on_area_2d_body_entered(body: Node2D) -> void:
	collectible_audio.play()
	
	sprite_2d.visible = false
	area_2d.set_deferred("monitoring", false)
	
	SignalManager.passColectible.emit(self)
	
	await collectible_audio.finished
	queue_free()
