extends Label

@export var blinkSpeed: float = 1
var storedText: String
var blinkTimer
var blinkToggle: bool

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	storedText = text
	blinkTimer = get_tree().create_timer(blinkSpeed)
	blinkToggle = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if visible:
		blink()

func blink():

	if blinkTimer.time_left <= 0.0:
		blinkTimer = get_tree().create_timer(blinkSpeed)
		await blinkTimer.timeout
		blinkToggle = !blinkToggle
		print("blink")
	
	if(blinkToggle):
		text = ""
	else:
		text = storedText
