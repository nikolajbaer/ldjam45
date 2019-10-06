extends Spatial

export var body_color = Color(255,0,255)
export var player = "p1"

var hud

func _ready():
	$VehicleBody.set_body_color(body_color)
	$VehicleBody.set_player(player)
	
func _process(dt):
	pass

func get_camera():
	return $VehicleBody/cambase/Viewport/Camera;
