extends Node2D

var worldScene = preload("res://Game.tscn")
var worldSceneInstance
var camera1
var camera2 
var viewport_sprite1
var viewport_sprite2

# Called when the node enters the scene tree for the first time.
func _ready():
	worldSceneInstance = worldScene.instance();
	self.add_child(worldSceneInstance);
	
	# Get the cameras
	camera1 = worldSceneInstance.get_node("VehicleBody").get_camera()
	camera2 = worldSceneInstance.get_node("VehicleBody2").get_camera()
	
	# Get the sprites
	viewport_sprite1 = get_node("Player1")
	viewport_sprite2 = get_node("Player2")
	
	# Assign the sprite's texture to the viewport texture
	camera1.get_viewport().set_clear_mode(Viewport.CLEAR_MODE_ONLY_NEXT_FRAME)
	camera2.get_viewport().set_clear_mode(Viewport.CLEAR_MODE_ONLY_NEXT_FRAME)
	
	
	# Assign the camera viewport textures to the sprites
	viewport_sprite1.texture = camera1.get_viewport().get_texture()
	viewport_sprite2.texture = camera2.get_viewport().get_texture()