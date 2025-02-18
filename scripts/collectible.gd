extends Node2D
class_name Collectible

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var area_2d: Area2D = $Area2D
@onready var collectible_audio: AudioStreamPlayer = $collectibleAudio


@export var sprite: Texture2D
@export var sound: AudioStreamWAV

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sprite_2d.texture = sprite
	collectible_audio.stream = sound

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_2d_body_entered(body: Node2D) -> void:
	collectible_audio.play()
	
	sprite_2d.visible = false
	area_2d.monitoring = false
	area_2d.set_deferred("monitorable", false)
	
	await collectible_audio.finished
	queue_free()
	print("free")
