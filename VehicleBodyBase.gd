extends Spatial

export var body_color = Color(255,0,255)
export var player = "p1"
onready var vehicle = $VehicleBody
onready var camera = $VehicleBody/cambase/Viewport/Camera

signal lap_completed

var hud
var base_fov

func _ready():
	vehicle.set_body_color(body_color)
	vehicle.set_player(player)
	base_fov = camera.fov
	
func _process(dt):
	camera.fov = base_fov + (vehicle.linear_velocity.length() / 100) * 30

func get_camera():
	return $VehicleBody/cambase/Viewport/Camera;

func _on_VehicleBody_lap_completed(lap_num,lap_time):
	emit_signal("lap_completed",lap_num,lap_time)

func ready_to_go():
	return camera.flying_in == false