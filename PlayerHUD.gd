extends Control

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var pickups = $HBoxContainer/VBoxContainer/Pickups
onready var lap = $HBoxContainer/VBoxContainer/Lap
onready var bestlap = $HBoxContainer/VBoxContainer/Bestlap
onready var elapsed = $HBoxContainer/VBoxContainer/Elapsed
onready var score = $HBoxContainer/VBoxContainer/Score
var vehicle = null

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if vehicle:
		pickups.text = "Junk: %s" % vehicle.pickups
		lap.text = "Current Lap %s" % vehicle.current_lap()
		if len(vehicle.laps) > 1:
			bestlap.text = "Best Lap: %s s" % vehicle.best_lap
		else:
			bestlap.text = " - "
		if len(vehicle.laps) > 0:
			elapsed.text = "Elapsed: %s" % vehicle.get_elapsed()
			score.text = "Score: %s" % vehicle.get_score()