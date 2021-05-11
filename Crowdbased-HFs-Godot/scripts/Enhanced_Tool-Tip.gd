tool
extends Control

#class_name Enhanced_Tool_Tip, "res://icon/Enhanced_Tool-Tip_Icon.svg"

var tool_tip = preload("res://addons/enhanced_tool-tip/PopUp.tscn").instance()

# Editor variables
export(String, MULTILINE) var body_text = ""
export var blog_button_url = "http://godotengine.org"
export var video_button_url = "https://www.youtube.com/watch?v=42HKCFf5Lf4"

# Variables
var tool_tip_instance
var show = false

func _enter_tree():
	#var _mouse_entered = self.connect("mouse_entered", self, "_on_Control_mouse_entered", [], CONNECT_PERSIST)
	#var _mouse_exited = self.connect("mouse_exited", self, "_on_Control_mouse_exited", [], CONNECT_PERSIST)
	print("entered tree")
	self.set_anchors_and_margins_preset(PRESET_WIDE)
	#_init_tool_tip()
	#_set_tool_tip_variables()
	#pass

# Initialize tool-tip position and content
func _ready():
	#print("Enhanced Tool-Tip ready!")
#	var _mouse_entered = self.connect("mouse_entered", self, "_on_Control_mouse_entered")
#	var _mouse_exited = self.connect("mouse_exited", self, "_on_Control_mouse_exited")
#	self.set_anchors_and_margins_preset(PRESET_WIDE)
#	_init_tool_tip()
#	_set_tool_tip_variables()
	pass


func _init_tool_tip():
	print("init tool-tip")
	#tool_tip_instance = tool_tip.instance()
	add_child(tool_tip_instance)

func _set_tool_tip_variables():
	tool_tip._set_Title(get_parent().get_name())
	# Use the Editor Description of the parent node if there is one
	if(body_text.empty()):
		body_text = get_parent().editor_description
	tool_tip._set_Body_Text(body_text)
	tool_tip._set_Blog_URL(blog_button_url)
	tool_tip._set_Video_URL(video_button_url)

# Handle visibility of tool-tip
func _process(_delta):
	print(tool_tip)
	if(tool_tip):
		add_child(tool_tip)
		_set_tool_tip_variables()
#	show = !_should_PopUp_hide()
#	#print(show)
#	#if(tool_tip_instance.mouse_hovered or show):
#	if(show or tool_tip_instance.mouse_hovered):
#		#print("tool: ",  tool_tip_instance.mouse_hovered)
#		yield(get_tree().create_timer(0.7), "timeout")
#		if has_node("PopUp"):
#			$"PopUp".show()
#	else:
#		yield(get_tree().create_timer(0.3), "timeout")
#		if has_node("PopUp"):
#			$"PopUp".hide()
	pass

func _on_Control_mouse_entered():
	print("mouse entered")
	tool_tip_instance.rect_position = get_global_mouse_position()
	show = true

func _on_Control_mouse_exited():
	print("mouse exited")
	show = false

func _should_PopUp_hide():
	var should_PopUp_hide = false

	var global_mouse_X = get_global_mouse_position().x
	var global_mouse_Y = get_global_mouse_position().y

	var popUp_X_1 = rect_global_position.x
	var popUp_X_2 = rect_global_position.x + rect_size.x
	var popUp_Y_1 = rect_global_position.y
	var popUp_Y_2 = rect_global_position.y + rect_size.y

	# Checks if the mouse is outside the PopUp Rectangle
	if((popUp_X_1 >= global_mouse_X or global_mouse_X >= popUp_X_2) or (popUp_Y_1 >= global_mouse_Y or global_mouse_Y >= popUp_Y_2)):
		should_PopUp_hide = true

	return should_PopUp_hide
