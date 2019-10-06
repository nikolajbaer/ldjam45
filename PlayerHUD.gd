extends Control

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var pickups = $HBoxContainer/VBoxContainer/Pickups
onready var lap = $HBoxContainer/VBoxContainer/Lap
onready var bestlap = $HBoxContainer/VBoxContainer/Bestlap
<<<<<<< HEAD
onready var elapsed = $HBoxContainer/VBoxContainer/Elapsed
onready var score = $HBoxContainer/VBoxContainer/Score
=======

onready var starttimer = $UIStartTimer
onready var gaptimer   = $UIGapTimer

onready var bongsound = $BongSound
onready var bingsound = $BingSound

onready var music = $Music

>>>>>>> 0ff13f3353feca51b524ba4d28c0c990ac1c69ca
var vehicle = null

# Called when the node enters the scene tree for the first time.

func _countdown_sounds():
	bongsound.play()
	starttimer.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if vehicle:
		pickups.text = "Junk: %s" % vehicle.pickups
		lap.text = "Current Lap %s" % vehicle.current_lap()
		if len(vehicle.laps) > 1:
			bestlap.text = "Best Lap: %s s" % vehicle.best_lap
		else:
			bestlap.text = " - "
<<<<<<< HEAD
		if len(vehicle.laps) > 0:
			elapsed.text = "Elapsed: %s" % vehicle.get_elapsed()
			score.text = "Score: %s" % vehicle.get_score()
=======

func _on_UIStartTimer_timeout():
	bongsound.stop()
	gaptimer.start(0.125)

func _on_BingSound_finished():
	music.play()

func _on_UIGapTimer_timeout():
	bingsound.play()	
>>>>>>> 0ff13f3353feca51b524ba4d28c0c990ac1c69ca
