extends Node2D

var worldScene = preload("res://Game.tscn")
var worldSceneInstance
var camera1
var camera2
onready var hud1 = $Player1_container/PlayerHUD
onready var hud2 = $Player2_container/PlayerHUD
var vehicle1
var vehicle2 
var viewport_sprite1
var viewport_sprite2


# Called when the node enters the scene tree for the first time.
func _ready():
	print(Input.get_connected_joypads())

	worldSceneInstance = worldScene.instance();
	self.add_child(worldSceneInstance);

	# Get the cameras
	vehicle1 = worldSceneInstance.get_node("VehicleBody")
	vehicle2 = worldSceneInstance.get_node("VehicleBody2")

	hud1.vehicle = vehicle1.get_node("VehicleBody")
	hud2.vehicle = vehicle2.get_node("VehicleBody")
	
	camera1 = vehicle1.get_camera()
	camera2 = vehicle2.get_camera()

	camera1.set_transform(vehicle1.get_transform())
	camera1.translate(Vector3(5.0, 130.0, 5.0))
	camera2.set_transform(vehicle2.get_transform())
	camera2.translate(Vector3(-5.0, 130.0, 5.0))
	# Get the sprites
	viewport_sprite1 = get_node("Player1_container/Player1")
	viewport_sprite2 = get_node("Player2_container/Player2")
	
	# Assign the sprite's texture to the viewport texture
	camera1.get_viewport().set_clear_mode(Viewport.CLEAR_MODE_ONLY_NEXT_FRAME)
	camera2.get_viewport().set_clear_mode(Viewport.CLEAR_MODE_ONLY_NEXT_FRAME)
	
	
	# Assign the camera viewport textures to the sprites
	viewport_sprite1.texture = camera1.get_viewport().get_texture()
	viewport_sprite2.texture = camera2.get_viewport().get_texture()