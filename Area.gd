extends Area

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var sound = $PickupSound

signal blobpickup

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Area_body_entered(body):
	if body is VehicleBody:
		emit_signal("blobpickup")
		body.add_pickup(self)
		self.queue_free()
