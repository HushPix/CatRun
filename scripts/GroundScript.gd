extends Node2D
class_name Ground

var speed: float
@export var animatable_body_2d: AnimatableBody2D 
@export var area_2d: Area2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _physics_process(delta: float) -> void:
	animatable_body_2d.move_and_collide(Vector2(-speed, 0))
	area_2d.move_local_x(-speed)
	
