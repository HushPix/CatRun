class_name Collectible extends Node2D

@export var sprite_2d: Sprite2D
@export var playerDetector: Area2D
@export var groundDetector: Area2D
@export var collectible_audio: AudioStreamPlayer 
@export var animatableBody: AnimatableBody2D
@export var data: CollectibleData
@export var animationPlayer: AnimationPlayer
@export var particleEmitter: GPUParticles2D

var type: CollectibleType.Type
var points: int
var speed: float 
var safetyOffset: float
var noGroundYet: bool = true
var spawnPos: Vector2
var anim_lib: AnimationLibrary

func setCollectibleData(collectibleData: CollectibleData):
	sprite_2d.texture = collectibleData.sprite.duplicate()
	collectible_audio.stream = collectibleData.sound
	points =collectibleData.points
	type = collectibleData.type
	particleEmitter.process_material = particleEmitter.process_material.duplicate()
	particleEmitter.process_material.color = collectibleData.particleColor
	
	anim_lib = AnimationLibrary.new()
	anim_lib.add_animation("idleAnim", collectibleData.idleAnim)
	anim_lib.add_animation("getAnim", collectibleData.getAnim)	
	animationPlayer.add_animation_library("collectibleAnims", anim_lib)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	setCollectibleData(data)
	spawnPos = global_position
	animationPlayer.play("collectibleAnims/idleAnim")

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
	playerDetector.set_deferred("monitoring", false)
	SignalManager.passColectible.emit(self)
	collectible_audio.play()
	animationPlayer.play("collectibleAnims/getAnim")
	
	if type == CollectibleType.Type.food:
		particleEmitter.restart()
		particleEmitter.emitting = true	
	
	await animationPlayer.animation_finished
	sprite_2d.visible = false
	SignalManager.deleteInstanceOfCollectible.emit(self)

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("despawnTrigger"):
		SignalManager.deleteInstanceOfCollectible.emit(self)


func _on_area_2d_body_entered(body) -> void:
	if body.is_in_group("player"):
		collectCoin()
	if body.is_in_group("collectible"):
		safelyOffset()

func move() -> void :
	if noGroundYet or groundDetector.has_overlapping_bodies():
		position.y -= 16
		
	if global_position.y  < 30:
		safelyOffset()
		
func safelyOffset() -> void:
	noGroundYet = true
	global_position.y = spawnPos.y
	global_position.x += safetyOffset

func _on_ground_area_body_entered(_body: Node2D) -> void:
	noGroundYet = false


func _on_ground_area_body_exited(_body: Node2D) -> void:
	pass
