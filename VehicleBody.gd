extends VehicleBody

# Member variables
const STEER_SPEED = 1
const STEER_LIMIT = 0.4

var steer_angle = 0
var steer_target = 0

var throttle_up = true
var throttle_down = false

var pickups = 0
var start_mass

signal countdown_started

onready var idle_sound = $EngineIdle
onready var throttle_sound = $EngineThrottleStart
onready var throttle_loop = $EngineThrottleLoop
onready var lbackwheel = $BackVehicleWheelL
onready var lspray = $BackVehicleWheelL/LSpray
onready var rbackwheel = $BackVehicleWheelR
onready var rspray = $BackVehicleWheelR/RSpray
onready var timer = get_parent().get_node("StartTimer")

export var engine_force_value = 400

var player
var pjoy
var checkpoint
var laps = null
var active = false
var initial_wheel_slip
var best_lap = null

func _ready():
	active = false
	start_mass = mass
	pickups = 0
	checkpoint = null
	laps = []
	best_lap = null
	initial_wheel_slip = lbackwheel.wheel_friction_slip
	# Now goes from Camera Fly-In
	#get_parent().get_node("StartTimer").start()

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
	lspray.emitting =  lbackwheel.get_skidinfo() < 0.8
	rspray.emitting =  rbackwheel.get_skidinfo() < 0.8
	
func reset_position():
	active = false
	get_parent().get_node("StartTimer").start()
	rotation = Vector3(0,0,0)
	translate_object_local( Vector3(0, 3, 0) ) # lift up
	linear_velocity = Vector3(0,0,0)
	angular_velocity = Vector3(0,0,0)
	
func _physics_process(delta):
	if not active: return
	
	var fwd_mps = transform.basis.xform_inv(linear_velocity).x

	if Input.is_action_pressed(player+"_reset") or translation.y < -50:
		reset_position()

	if Input.is_action_pressed(player+"_ebrake"):
		lbackwheel.wheel_friction_slip = 0.4 * initial_wheel_slip
		rbackwheel.wheel_friction_slip = 0.4 * initial_wheel_slip
	else:
		lbackwheel.wheel_friction_slip = initial_wheel_slip
		rbackwheel.wheel_friction_slip = initial_wheel_slip
		

	if Input.is_action_pressed(player+"_left"):
		steer_target = STEER_LIMIT
	elif Input.is_action_pressed(player+"_right"):
		steer_target = -STEER_LIMIT
	else:
		steer_target = 0
	
	if Input.is_action_pressed(player+"_engine") or Input.is_joy_button_pressed(pjoy, JOY_BUTTON_0):
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
			#idle_sound.play()
			pass
			
	if Input.is_action_pressed(player+"_brake") or Input.is_joy_button_pressed(pjoy,JOY_BUTTON_1):
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

func add_pickup(area):
	pickups += 1
	mass = start_mass + pickups

func set_checkpoint(c):
	if checkpoint != null and \
		( not ( c.sequence == 0 and checkpoint.sequence == 9 ) ) and \
		( checkpoint.sequence + 1 != c.sequence):
		return
	print("Set Checkpoint %s " % c.sequence)
	checkpoint = c
	if checkpoint.sequence == 0:
		laps.append( OS.get_ticks_msec() ) # Todo save global time in seconds
		var lap_time = (laps[len(laps) - 1] - laps[len(laps) - 2]) / 1000
		if len(laps) > 1:
			print( "Lap %s Complete" % (len(laps)-1) )
			print("Lap Time %s seconds " % lap_time )
		print("Lap %s Started" % len(laps) )
		if len(laps) > 1 and ( best_lap == null or best_lap > lap_time ):
			print("Setting best lap from ",best_lap,lap_time)
			best_lap = lap_time

func _on_StartTimer_timeout():
	print("Activating Player "+player)
	active = true

func _on_Camera_flyin_complete():
	timer.start()
	emit_signal("countdown_started")
