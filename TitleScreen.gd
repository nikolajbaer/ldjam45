extends Node2D

var splitscreen = preload("res://SplitScreen.tscn")
var player1 = false
var player2 = false
onready var instructions = $Instructions

# TODO
# https://docs.godotengine.org/en/3.1/getting_started/step_by_step/ui_main_menu.html

func _ready():
	if len(Input.get_connected_joypads()) < 2:
		$JoystickWarning.visible = true
		

func player1_joined():
	$Control/Player1/Prompt.visible = false
	$Control/Player1/Joined.visible = true
	player1 = true
	

func player2_joined():
	$Control/Player2/Prompt.visible = false
	$Control/Player2/Joined.visible = true
	player2 = true
	
func show_instructions():
	instructions.show()
	
func hide_instructions():
	instructions.hide()
	

func _input(event):
	if event is InputEventKey:
		var e = event as InputEventKey
		if e.pressed and e.scancode in [KEY_W,KEY_A,KEY_S,KEY_D]:
			player1_joined()
		elif e.pressed and e.scancode in [KEY_I,KEY_J,KEY_K,KEY_L]:
			player2_joined()

func start_game():
	get_tree().change_scene_to(splitscreen)

func _on_NewGameButton_pressed():
	start_game()


func _on_Instructions_pressed():
	show_instructions()


func _on_CloseButton_pressed():
	hide_instructions()
