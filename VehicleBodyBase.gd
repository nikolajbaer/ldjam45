extends Spatial

export var body_color = Color(255,0,255)
export var player = "p1"
onready var vehicle = $VehicleBody

signal lap_completed

var hud

func _ready():
	vehicle.set_body_color(body_color)
	vehicle.set_player(player)
	
func _process(dt):
	pass

func get_camera():
	return $VehicleBody/cambase/Viewport/Camera;

func _on_VehicleBody_lap_completed(lap_num,lap_time):
	emit_signal("lap_completed",lap_num,lap_time)
