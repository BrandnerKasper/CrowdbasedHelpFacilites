extends Control

class_name Enhanced_Tool_Tip, "res://icon/Enhanced_Tool-Tip_Icon.svg"

onready var tool_tip = preload("res://scenes/PopUp.tscn") 

# Editor variables
export(String, MULTILINE) var body_text = ""
export var blog_button_url = "http://godotengine.org"
export var video_button_url = "https://www.youtube.com/watch?v=42HKCFf5Lf4"

# Variables
var control_width
var control_height
var tool_tip_instance
var tool_tip_offset
var show = false


# Initialize tool-tip position and content
func _ready():
	#print("Enhanced Tool-Tip ready!")
	var _mouse_entered = self.connect("mouse_entered", self, "_on_Control_mouse_entered")
	var _mouse_exited = self.connect("mouse_exited", self, "_on_Control_mouse_exited")
	self.set_anchors_and_margins_preset(PRESET_WIDE)
	_init_tool_tip()
	_set_tool_tip_variables()
	
	
func _init_tool_tip():
	control_width = get_parent_area_size().x
	control_height = get_parent_area_size().y
	#print("width: ", control_width, " height: ", control_height)

	tool_tip_instance = tool_tip.instance()
	
	tool_tip_offset = Vector2(-control_width + control_width/5,  tool_tip_instance.rect_size.y)
	tool_tip_instance.rect_position = get_global_transform_with_canvas().origin - tool_tip_offset
	
	add_child(tool_tip_instance)

func _set_tool_tip_variables():
	tool_tip_instance._set_Title(get_parent().get_name())
	# Use the Editor Description of the parent node if there is one
	if(body_text.empty()):
		body_text = get_parent().editor_description
	tool_tip_instance._set_Body_Text(body_text)
	tool_tip_instance._set_Blog_URL(blog_button_url)
	tool_tip_instance._set_Video_URL(video_button_url)

# Handle visibility of tool-tip
func _process(_delta):
	#print("show: ", show)
	
	if(tool_tip_instance.mouse_hovered or show):
		#print("tool: ",  tool_tip_instance.mouse_hovered)
		yield(get_tree().create_timer(0.7), "timeout")
		if has_node("PopUp"):
			$"PopUp".show()
	else:
		yield(get_tree().create_timer(0.3), "timeout")
		if has_node("PopUp"):
			$"PopUp".hide()


func _on_Control_mouse_entered():
	show = true

func _on_Control_mouse_exited():
	show = false
