extends AnimatedSprite

onready var tool_tip = preload("res://scenes/PopUp.tscn") 

#export var title = "Title of Game Object"
export var body_text = "Default Text"
export var blog_button_url = "http://godotengine.org"
export var video_button_url = "https://www.youtube.com/watch?v=42HKCFf5Lf4"


func _ready():
	print("readdy")
	var tool_tip_instance = tool_tip.instance()
	#tool_tip_instance.rect_position = get_global_transform_with_canvas().origin - Vector2($Control.rect_size)
	#tool_tip_instance.rect_size = $Control.rect_size
	
	add_child(tool_tip_instance)
	tool_tip_instance.title = get_name()
	tool_tip_instance.body_text = body_text
	tool_tip_instance.blog_button_url = blog_button_url
	tool_tip_instance.video_button_url = video_button_url



func _on_Control_mouse_entered():
	yield(get_tree().create_timer(0.3), "timeout")
	if has_node("PopUp"):
		$"PopUp".show()


func _on_Control_mouse_exited():
	if has_node("PopUp"):
		$"PopUp".hide()
