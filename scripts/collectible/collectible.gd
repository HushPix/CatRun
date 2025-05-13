class_name Collectible extends Node2D

@export var sprite_2d: Sprite2D
@export var playerDetector: Area2D
@export var groundDetector: Area2D
@export var collectible_audio: AudioStreamPlayer 
@export var animatableBody: AnimatableBody2D
@export var data: CollectibleData

var type: CollectibleType.Type
var points: int
var speed: float 
var safetyOffset: float
var noGroundYet: bool = true

func setCollectibleData(collectibleData: CollectibleData):
	sprite_2d.texture = collectibleData.sprite
	collectible_audio.stream = collectibleData.sound
	points =collectibleData.points
	type = collectibleData.type

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	setCollectibleData(data)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
	
func _physics_process(_delta: float) -> void:
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
	if noGroundYet or groundDetector.has_overlapping_bodies():
		position.y -= 16
		
	if global_position.y  < 30:
		noGroundYet = true
		global_position.y = 172
		global_position.x += safetyOffset
		


func _on_ground_area_body_entered(_body: Node2D) -> void:
	noGroundYet = false


func _on_ground_area_body_exited(_body: Node2D) -> void:
	pass
