extends Spatial


export var lap_count = 3
var hud1
var hud2

func _ready():
	pass

func try_start():
	if $VehicleBody.ready_to_go() and $VehicleBody2.ready_to_go():
		start_game()

func start_game():
	hud1._countdown_sounds()
	
		
