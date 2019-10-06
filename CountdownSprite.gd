extends Sprite

var index = 0
onready var countdown_array = [
	preload("res://countdown_3.png"),
	preload("res://countdown_2.png"),
	preload("res://countdown_1.png"),
	preload("res://countdown_go.png")
]

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	visible = false
	index = 0


func increment_index():
	index += 1
	if index > 3:
		visible = false
	else:
		texture = countdown_array[index]

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
