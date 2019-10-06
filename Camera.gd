extends Camera

# Member variables
var collision_exception = []
export var min_distance = 10
export var max_distance = 20.0
export var angle_v_adjust = 0.0
export var autoturn_ray_aperture = 25
export var autoturn_speed = 50
var max_height = 1.0
var min_height = 0.5
var flying_in = true

signal flyin_complete

func _physics_process(dt):
	
	var vehicle_body = get_parent().get_parent().get_parent()
	var target = vehicle_body.get_global_transform().origin
	var pos = get_transform().origin
	var up = Vector3(0, 1, 0)
	target.y += 5
	
	var delta = pos - target
	
	# Regular delta follow
	# Check ranges
	if !flying_in:
		if (delta.length() < min_distance):
			delta = delta.normalized()*min_distance
		elif (delta.length() > max_distance):
			delta = delta.normalized()*max_distance
		
		# Check upper and lower height
		if ( delta.y > max_height):
			delta.y = max_height
		if ( delta.y < min_height):
			delta.y = min_height
					
	pos = target + delta
	
	look_at_from_position(pos, target, up)
	if flying_in:
		#translate(Vector3(1.0,0,0))
		var d = target - get_transform().origin
		#print(d.length(), d/100.0)
		translate(d/100.0)
		if d.length() < max_distance:
			flying_in = false
			emit_signal("flyin_complete")
			
	# Turn a little up or down
	var t = get_transform()
	t.basis = Basis(t.basis[0], deg2rad(angle_v_adjust))*t.basis
	set_transform(t)


func _ready():
	# Find collision exceptions for ray
	var node = self
	while(node):
		if (node is RigidBody):
			collision_exception.append(node.get_rid())
			break
		else:
			node = node.get_parent().get_parent()
	
	# This detaches the camera transform from the parent spatial node
	set_as_toplevel(true)
