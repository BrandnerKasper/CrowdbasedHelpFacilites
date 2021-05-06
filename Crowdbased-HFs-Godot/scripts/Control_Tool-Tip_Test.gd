extends Control

onready var tool_tip = preload("res://scenes/PopUp.tscn") 

# Editor variables
export var body_text = "Default Text"
export var blog_button_url = "http://godotengine.org"
export var video_button_url = "https://www.youtube.com/watch?v=42HKCFf5Lf4"

# Variables
var control_width
var control_height
var tool_tip_instance
var show = false

# Initialize tool-tip position and content
func _ready():
	_init_tool_tip()
	_set_tool_tip_variables()
	
	
func _init_tool_tip():
	control_width = rect_size.x
	control_height = rect_size.y

	tool_tip_instance = tool_tip.instance()
	tool_tip_instance.rect_position = get_global_transform_with_canvas().origin - Vector2(-control_width + 20, control_height + 100)
	
	add_child(tool_tip_instance)

func _set_tool_tip_variables():
	tool_tip_instance._set_Title(get_parent().get_name())
	tool_tip_instance._set_Body_Text(body_text)
	tool_tip_instance._set_Blog_URL(blog_button_url)
	tool_tip_instance._set_Video_URL(video_button_url)

# Handle visibility of tool-tip
func _process(_delta):
	
	if(tool_tip_instance.mouse_hovered or show):
		#print("tool: ",  tool_tip_instance.mouse_hovered)
		yield(get_tree().create_timer(0.3), "timeout")
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
