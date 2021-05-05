extends Popup
# maybe get parent name as title?

# Editor variables
export var title = "Title of Game Object"
export var body_text = "Default Text"
export var blog_button_url = "http://godotengine.org"
export var video_button_url = "https://www.youtube.com/watch?v=42HKCFf5Lf4"

# Variables
var like = 0
var dislike = 0
var mouse_hovered = false

#Debug
var entered = 0
var exited = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	show()
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	_handle_Title_changed()
	_handle_Body_Text_changed()
	_handle_Like_Number_Changed()
	_handle_DisLike_Number_Changed()
	#if Engine.editor_hint:
		#print("Now print while in editor")

# Handle Editor Variables
func _handle_Title_changed():
	$"Nine/Base-M/Base-C/Title-C/Title-Center/Title".text = title

func _handle_Body_Text_changed():
	$"Nine/Base-M/Base-C/Body-M/Body-C/Scroll-C/Text_Body".text = body_text

func _handle_Like_Number_Changed():
	$"Nine/Base-M/Base-C/Rating-Center/Rating-C/DisLike-M/DisLike-C/DisLike_Number".text = String(dislike)

func _handle_DisLike_Number_Changed():
	$"Nine/Base-M/Base-C/Rating-Center/Rating-C/Rating-M/Like-C/Like_Number".text = String(like)


#Handle Buttons
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


func _on_PopUp_mouse_entered():
	mouse_hovered = true
	print("entered: ", mouse_hovered)

#Problem upper Ui elements eat input of mouse hovering, so we have to make clear that we REALLY exited the PopUp
func _on_PopUp_mouse_exited():
	var global_mouse_x = get_global_mouse_position().x
	var global_mouse_y = get_global_mouse_position().y
	
	var rectx1 = rect_global_position.x
	var rectx2 = rect_global_position.x + rect_size.x
	var recty1 = rect_global_position.y
	var recty2 = rect_global_position.y + rect_size.y
	#var Rect01 = Vector2(rectx1, recty1)
	#var Rect02 = Vector2(rectx2, recty2)
	
	#print(get_global_mouse_position(), Rect01, Rect02)
	if((rectx1 >= global_mouse_x or global_mouse_x >= rectx2) or (recty1 >= global_mouse_y or global_mouse_y >= recty2)):
		mouse_hovered = false
		print("exited: ", mouse_hovered)
