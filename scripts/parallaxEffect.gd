class_name ParallaxEffect
extends Node2D

var gameSpeed: float
@export var gameplay: Gameplay
@export var ground_bg: Parallax2D
@export var clouds_bg: Parallax2D
@export var sky_bg: Parallax2D
@export var bg_bg: Parallax2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalManager.difficultyChange.connect(on_difficulty_change)
	
func on_difficulty_change(unused) -> void:
	gameSpeed = gameplay.getSpeed()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	clouds_bg.autoscroll.x = gameSpeed * -20.0
	bg_bg.autoscroll.x = gameSpeed * -30.0
	ground_bg.autoscroll.x = gameSpeed * -50.0
	sky_bg.autoscroll.x = int(gameSpeed * -10)
	
