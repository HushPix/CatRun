class_name Collectible extends Node2D

@export var sprite_2d: Sprite2D
@export var collider: Area2D
@export var collectible_audio: AudioStreamPlayer 
@export var animatableBody: AnimatableBody2D
var data: CollectibleData

var type: CollectibleType.Type
var points: int
var speed: float = 2

func setCollectibleData(data: CollectibleData):
	sprite_2d.texture = data.sprite
	collectible_audio.stream = data.sound
	points = data.points
	type = data.type

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	setCollectibleData(data)
	print("coinSpawned")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	animatableBody.move_and_collide(Vector2(-speed, 0))

func get_type() -> CollectibleType.Type:
	return type
	
func get_points() -> int:
	return points

func _on_area_2d_body_entered(body: Player) -> void:
	collectible_audio.play()
	
	sprite_2d.visible = false
	collider.set_deferred("monitoring", false)
	
	SignalManager.passColectible.emit(self)
	
	await collectible_audio.finished
	queue_free()

func _on_area_2d_ground_enter(body: TileMapLayer) -> void:
	position.y += 16
	
