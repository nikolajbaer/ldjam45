extends Spatial

export var body_color = Color(255,0,255)
export var player = "p1"


func _ready():
	$VehicleBody.set_body_color(body_color)
	$VehicleBody.player = player

func get_camera():
	return $VehicleBody/cambase/Viewport/Camera;