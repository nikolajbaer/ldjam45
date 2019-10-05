extends VehicleBody
	
onready var idle_sound = $EngineIdle
onready var throttle_sound = $EngineThrottle
onready var lspray = $LSpray
onready var rspray = $RSpray


func _ready():
	pass

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
		self.engine_force = -1000
	
	if Input.is_action_pressed("left"):
		if self.steering < .5:
			self.steering += 0.01
	elif Input.is_action_pressed("right"):
		if self.steering > -.5:
			self.steering -= 0.01
	else:
		if self.steering < -0.01:
			self.set_steering( self.steering + 0.01 )
		elif self.steering > 0.01:
			self.set_steering( self.steering - 0.01 )

func _on_VehicleBody_body_entered(body):
	if body.get_collision_layer_bit(1):
		print("Bang")
		$CrashSound.play()

