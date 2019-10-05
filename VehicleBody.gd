extends VehicleBody
	
onready var idle_sound = $EngineIdle
onready var throttle_sound = $EngineThrottle
onready var lspray = $LSpray
onready var rspray = $RSpray

func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_pressed('engine'):
		self.engine_force = 8000
		lspray.emitting = true
		rspray.emitting = true
		idle_sound.stop()
		if not throttle_sound.playing:
			throttle_sound.play()
	else:
		lspray.emitting = false
		rspray.emitting = false
		self.engine_force = 0
		throttle_sound.stop()
		if not idle_sound.playing:
			idle_sound.play()
	
	if Input.is_action_pressed('brake'):
		self.brake = 1000
		if self.linear_velocity.length() <= 0:
			self.engine_force = -1000
	else:
		self.brake = 0
		if self.engine_force < 0:
			self.engine_force = 0
	
	if Input.is_action_pressed("left"):
		self.set_steering(.5)
	elif Input.is_action_pressed("right"):
		self.set_steering(-.5)
	else:
		self.set_steering(0)



func _on_VehicleBody_body_entered(body):
	if body.get_collision_layer_bit(1):
		print("Bang")
		$CrashSound.play()

