extends Node

# sort of like a global signal bus.
# It allows me to send signals to any node, no matter
# it's position in tree

signal passColectible(currCollectible: Collectible)
signal saveCollectibles()
signal loadCollectibles()


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
