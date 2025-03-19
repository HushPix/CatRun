class_name Collectible extends Node2D

@export var sprite_2d: Sprite2D
@export var playerDetector: Area2D
@export var groundDetector: Area2D
@export var collectible_audio: AudioStreamPlayer 
@export var animatableBody: AnimatableBody2D
@export var data: CollectibleData

var type: CollectibleType.Type
var points: int
var speed: float = 2
var isInGround: bool

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
	
func _physics_process(delta: float) -> void:
	animatableBody.move_and_collide(Vector2(-speed, 0))
	move()


func get_type() -> CollectibleType.Type:
	return type
	
func get_points() -> int:
	return points
	
func collectCoin() -> void:
	collectible_audio.play()
	
	sprite_2d.visible = false
	playerDetector.set_deferred("monitoring", false)
	
	SignalManager.passColectible.emit(self)
	
	await collectible_audio.finished
	SignalManager.deleteInstanceOfCollectible.emit(self)

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("despawnTrigger"):
		SignalManager.deleteInstanceOfCollectible.emit(self)


func _on_area_2d_body_entered(body) -> void:
	if body.is_in_group("player"):
		collectCoin()

func move() -> void :
	if groundDetector.has_overlapping_bodies():
		position.y -= 16
		
func _on_ground_area_body_entered(body: Node2D) -> void:
	isInGround = true


func _on_ground_area_body_exited(body: Node2D) -> void:
	isInGround = false
