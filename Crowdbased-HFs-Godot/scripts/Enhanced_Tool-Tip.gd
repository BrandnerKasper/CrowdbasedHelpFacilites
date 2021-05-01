extends Control

# maybe get parent name as title?

# Editor variables
export var title = "Title of Game Object"
export var body_text = "Default Text"
export var blog_button_url = "http://godotengine.org"
export var video_button_url = "https://www.youtube.com/watch?v=42HKCFf5Lf4"

# Variables
var like = 0
var dislike = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	_handle_Title_changed()
	_handle_Body_Text_changed()
	_handle_Like_Number_Changed()
	_handle_DisLike_Number_Changed()
	if Engine.editor_hint:
		print("Now print while in editor")


func _handle_Title_changed():
	$"Base/Base-M/Base-C/Title-C/Title-Center/Title".text = title


func _handle_Body_Text_changed():
	$"Base/Base-M/Base-C/Body-M/Body-C/Scroll-C/Text_Body".text = body_text


func _handle_Like_Number_Changed():
	$"Base/Base-M/Base-C/Rating-Center/Rating-C/DisLike-M/DisLike-C/DisLike_Number".text = String(dislike)

func _handle_DisLike_Number_Changed():
	$"Base/Base-M/Base-C/Rating-Center/Rating-C/Rating-M/Like-C/Like_Number".text = String(like)

func _on_Blog_Button_pressed():
	print("Blog Button pressed.")
	var _open_blog = OS.shell_open(blog_button_url)
	if(_open_blog != 0):
		print("No valid path")


func _on_Video_Button_pressed():
	print("Video Button pressed.")
	var _open_video = OS.shell_open(video_button_url)
	if(_open_video != 0):
		print("No valid path")


func _on_Like_Button_pressed():
	print("Like Button pressed.")
	like += 1


func _on_DisLike_Button_pressed():
	print("DisLike Button pressed.")
	dislike += 1
