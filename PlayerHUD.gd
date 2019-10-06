extends Control

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var pickups = $Pickups
onready var lap = $Lap
onready var bestlap = $Bestlap
onready var elapsed = $Elapsed
onready var score = $Score
onready var turbo_available = $fastForward
onready var speedometer = $Speedometer
onready var starttimer = $UIStartTimer
onready var gaptimer   = $UIGapTimer
onready var boost = $boost

onready var bongsound = $BongSound
onready var bingsound = $BingSound

onready var music = $Music

onready var countdownsprite = $CountdownSprite
onready var countdowntimer = $UICountdownTimer

onready var boosttimer = $BoostTimer

var vehicle = null

# Called when the node enters the scene tree for the first time.

func _countdown_sounds():
	bongsound.play()
	starttimer.start()

func _countdown_graphics():
	countdowntimer.start()
	countdownsprite.visible = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if vehicle:
		pickups.text = "Junk: %s" % vehicle.pickups
		lap.text = "Current Lap %s" % vehicle.current_lap()
		if len(vehicle.laps) > 1:
			bestlap.text = "Best Lap: %s s" % vehicle.best_lap
		else:
			bestlap.text = " - "
		if vehicle.start_time != null:
			elapsed.text = "Elapsed: %s" % vehicle.get_elapsed()
			score.text = "Score: %s" % vehicle.get_score()
		turbo_available.visible = vehicle.turbo_boost > 0
		if !boost.visible && vehicle.boost_on > 0:		
			boost.visible = true
			boosttimer.start()
			
		
		speedometer.text = "%03d kmph" % int(vehicle.current_speed())

func _on_UIStartTimer_timeout():
	bongsound.stop()
	gaptimer.start(0.125)

func _on_BingSound_finished():
	music.play()

func _on_UIGapTimer_timeout():
	bingsound.play()	


func _on_UICountdownTimer_timeout():
	countdownsprite.increment_index()

func set_finished(score):
	$FinishedControl.visible = true
	$FinishedControl/score.text = "Score: %s" % score

func set_winner():
	$FinishedControl/finished.visible = false
	$FinishedControl/winner.visible = true


func _on_BoostTimer_timeout():
	boost.visible = false
