extends Spatial


export var lap_count = 1
var hud1
var hud2
var mode = "pvp"

onready var player1 = $VehicleBody/VehicleBody
onready var player2 = $VehicleBody2/VehicleBody

func _ready():
	pass

func try_start():
	if mode =="pvp":
		if $VehicleBody.ready_to_go() and $VehicleBody2.ready_to_go():
			start_game()
	elif mode == "tt":
		if $VehicleBody.ready_to_go():
			start_game()

func start_game():
	hud1._countdown_sounds()
	hud1._countdown_graphics()
	$VehicleBody/VehicleBody.timer.start()
	
	if mode == "pvp":
		hud2._countdown_graphics()
		$VehicleBody2/VehicleBody.timer.start()

func _on_VehicleBody_lap_completed(lap_num,lap_time):
	if mode == "pvp":
		if player1.laps_completed() == lap_count and not player1.finished:
			player1.set_finished()
			hud1.set_finished(player1.get_score())
		if player2.laps_completed() == lap_count and not player2.finished:
			player2.set_finished()
			hud2.set_finished(player2.get_score())
			
		if player1.finished and player2.finished:
			var winner = hud1
			if player2.get_score() < player1.get_score():
				winner = hud2
			winner.set_winner()

	elif mode == "tt":
		if player1.best_lap == null or lap_time < player1.best_lap:
			hud1.announce_best_lap(lap_time)

