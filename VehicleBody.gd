extends VehicleBody

# Member variables
const STEER_SPEED = 1
const STEER_LIMIT = 0.4

var steer_angle = 0
var steer_target = 0

onready var idle_sound = $EngineIdle
onready var throttle_sound = $EngineThrottle
onready var lspray = $LSpray
onready var rspray = $RSpray

export var engine_force_value = 400

func _physics_process(delta):
	var fwd_mps = transform.basis.xform_inv(linear_velocity).x
	
	if Input.is_action_pressed("left"):
		steer_target = STEER_LIMIT
	elif Input.is_action_pressed("right"):
		steer_target = -STEER_LIMIT
	else:
		steer_target = 0
	
	if Input.is_action_pressed("engine"):
		engine_force = engine_force_value
		lspray.emitting = true
		rspray.emitting = true
		idle_sound.stop()
		if not throttle_sound.playing:
			throttle_sound.play()
	else:
		lspray.emitting = false
		rspray.emitting = false
		engine_force = 0
	
	if Input.is_action_pressed("brake"):
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


func _on_VehicleBody_body_entered(body):
	if body.get_collision_layer_bit(1):
		print("Bang")
		$CrashSound.play()