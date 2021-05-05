extends Control

onready var tool_tip = preload("res://scenes/PopUp.tscn") 

#export var title = "Title of Game Object"
export var body_text = "Default Text"
export var blog_button_url = "http://godotengine.org"
export var video_button_url = "https://www.youtube.com/watch?v=42HKCFf5Lf4"
var control_width
var control_height
var tool_tip_instance
var show = false

func _ready():
	control_width = rect_size.x
	control_height = rect_size.y

	tool_tip_instance = tool_tip.instance()
	tool_tip_instance.rect_position = get_global_transform_with_canvas().origin - Vector2(-control_width, control_height/2)
	
	add_child(tool_tip_instance)
	tool_tip_instance.title = get_parent().get_name()
	tool_tip_instance.body_text = body_text
	tool_tip_instance.blog_button_url = blog_button_url
	tool_tip_instance.video_button_url = video_button_url

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
	pass
