extends Popup

# Variables
var blog_url = "String"
var video_url = "String"
var like = 0
var dislike = 0
var mouse_hovered = false


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	_handle_Like_Number_Changed()
	_handle_DisLike_Number_Changed()


# Handle Editor Variables
func _set_Title(title):
	$"Nine/Base-M/Base-C/Title-C/Title-Center/Title".text = title

func _set_Body_Text(body_text):
	$"Nine/Base-M/Base-C/Body-M/Body-C/Scroll-C/Text_Body".text = body_text

func _set_Blog_URL(url):
	blog_url = url

func _set_Video_URL(url):
	video_url = url

func _handle_Like_Number_Changed():
	$"Nine/Base-M/Base-C/Rating-Center/Rating-C/DisLike-M/DisLike-C/DisLike_Number".text = String(dislike)

func _handle_DisLike_Number_Changed():
	$"Nine/Base-M/Base-C/Rating-Center/Rating-C/Rating-M/Like-C/Like_Number".text = String(like)


#Handle Buttons
func _on_Blog_Button_pressed():
	print("Blog Button pressed.")
	var _open_blog = OS.shell_open(blog_url)
	if(_open_blog != 0):
		print("No valid path")

func _on_Video_Button_pressed():
	print("Video Button pressed.")
	var _open_video = OS.shell_open(video_url)
	if(_open_video != 0):
		print("No valid path")

func _on_Like_Button_pressed():
	print("Like Button pressed.")
	like += 1
	_handle_Like_Number_Changed()

func _on_DisLike_Button_pressed():
	print("DisLike Button pressed.")
	dislike += 1
	_handle_DisLike_Number_Changed()


# Handle visibility of Tool-Tip PopUp 
func _on_PopUp_mouse_entered():
	mouse_hovered = true
	print("entered: ", mouse_hovered)

func _on_PopUp_mouse_exited():
	if(_should_PopUp_hide()):
		mouse_hovered = false
		print("exited: ", mouse_hovered)

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

