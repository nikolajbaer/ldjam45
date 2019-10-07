extends Node2D

var worldScene = preload("res://Game.tscn")
var worldSceneInstance
var camera1
onready var hud1 = $Player1_Container/PlayerHUD
var vehicle1
var vehicle2 
var viewport_sprite1


# Called when the node enters the scene tree for the first time.
func _ready():
	print(Input.get_connected_joypads())

	worldSceneInstance = worldScene.instance();
	worldSceneInstance.mode = "tt"
	self.add_child(worldSceneInstance);

	# Get the cameras
	vehicle1 = worldSceneInstance.get_node("VehicleBody")
	vehicle2 = worldSceneInstance.get_node("VehicleBody2")
	vehicle2.queue_free()

	worldSceneInstance.hud1 = hud1
	hud1.vehicle = vehicle1.get_node("VehicleBody") 
	hud1.vehicle.connect("countdown_started", self, "_start_game")
	#hud1.vehicle.connect("countdown_started", hud1, "_countdown_graphics")
	
	camera1 = vehicle1.get_camera()
	camera1.get_parent().size.y = 600
	
	camera1.set_transform(vehicle1.get_transform())
	camera1.translate(Vector3(25.0, 90.0, 5.0))
	# Get the sprites
	viewport_sprite1 = get_node("Player1_Container/Player1")
	
	# Assign the sprite's texture to the viewport texture
	camera1.get_viewport().set_clear_mode(Viewport.CLEAR_MODE_ONLY_NEXT_FRAME)
	
	
	# Assign the camera viewport textures to the sprites
	viewport_sprite1.texture = camera1.get_viewport().get_texture()

func _start_game():
	worldSceneInstance.try_start()
