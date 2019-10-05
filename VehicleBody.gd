extends VehicleBody

# Member variables
const STEER_SPEED = 1
const STEER_LIMIT = 0.4

var steer_angle = 0
var steer_target = 0

var throttle_up = true
var throttle_down = false


onready var idle_sound = $EngineIdle
onready var throttle_sound = $EngineThrottleStart
onready var throttle_loop = $EngineThrottleLoop
onready var lbackwheel = $BackVehicleWheelL
onready var lspray = $BackVehicleWheelL/LSpray
onready var rbackwheel = $BackVehicleWheelR
onready var rspray = $BackVehicleWheelR/RSpray

export var engine_force_value = 400

var player
var pjoy

func set_body_color(body_color):
	var mat = $hearse.get_surface_material(0).duplicate()
	mat.albedo_color = body_color
	$hearse.set_surface_material(0,mat)
	
func set_player(p):
	player = p
	if p == "p1":
		pjoy = 0
	elif p == "p2":
		pjoy = 1

func update_spray():
	lspray.emitting =  (engine_force > 0 and lbackwheel.is_in_contact()) \
						or lbackwheel.get_skidinfo() < 0.5
	rspray.emitting =  (engine_force > 0 and rbackwheel.is_in_contact()) \
						or rbackwheel.get_skidinfo() < 0.5
	
func _physics_process(delta):
	var fwd_mps = transform.basis.xform_inv(linear_velocity).x

	if Input.is_action_pressed(player+"_reset"):
		var reset = Transform()
		reset.translated( translation - get_parent().translation )
		reset.translated(Vector3(0,0,3))
		transform = reset
		linear_velocity = Vector3(0,0,0)
		angular_velocity = Vector3(0,0,0)
		

	if Input.is_action_pressed(player+"_left"):
		steer_target = STEER_LIMIT
	elif Input.is_action_pressed(player+"_right"):
		steer_target = -STEER_LIMIT
	else:
		steer_target = 0
	
	# Nope
	var updown = 0 #Input.get_joy_axis(pjoy,JOY_AXIS_1)
	
	if Input.is_action_pressed(player+"_engine") or updown > 0:
		engine_force = engine_force_value
		idle_sound.stop()
		if not throttle_sound.playing && throttle_up:
			throttle_up = false
			throttle_sound.play()
		elif not throttle_sound.playing && not throttle_loop.playing:
			throttle_loop.play()
	else:
		engine_force = 0
		throttle_sound.stop()
		throttle_loop.stop()
		throttle_up = true
		if not idle_sound.playing:
			pass #idle_sound.play()
			
	if Input.is_action_pressed(player+"_brake") or updown < 0:
		if (fwd_mps >= -1):
			engine_force = -engine_force_value
		else:
			brake = 1
	else:
		brake = 0.0
	
	if steer_target < steer_angle:
		steer_angle -= STEER_SPEED * delta
		if steer_target > steer_angle:
			steer_angle = steer_target
	elif steer_target > steer_angle:
		steer_angle += STEER_SPEED * delta
		if steer_target < steer_angle:
			steer_angle = steer_target
	
	steering = steer_angle
	update_spray()


func _on_VehicleBody_body_entered(body):
	if body.get_collision_layer_bit(1):
		print("Bang")
		$CrashSound.play()