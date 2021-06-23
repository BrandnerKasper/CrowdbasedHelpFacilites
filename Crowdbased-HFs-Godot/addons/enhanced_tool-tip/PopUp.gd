extends Popup


# Signals
signal like_pressed(like_count)
signal dislike_pressed(dislike_count)

# Variables
var blog_url = "String"
var video_url = "String"
var like = 0
var dislike = 0
var mouse_hovered = false

# Like / DisLike Handling and mimic Youtube Button behaviour
var like_button
var dislike_button
var like_count_label
var dislike_count_label
var grey_color = Color(0.828125, 0.828125, 0.828125, 1)
var like_color = Color(0.2734375, 0.98828125, 0.515625, 1)
var dislike_color = Color(0.953125, 0.57421875, 0.296875, 1)
var like_pressed = false
const like_normal_texture = preload("res://addons/enhanced_tool-tip/textures/Like_Test_01.png")
const like_pressed_texture = preload("res://addons/enhanced_tool-tip/textures/Like_Test_03.png")
var dislike_pressed = false
const dislike_normal_texture = preload("res://addons/enhanced_tool-tip/textures/DisLike_Test_01.png")
const dislike_pressed_texture = preload("res://addons/enhanced_tool-tip/textures/DisLike_Test_03.png")


# Called when the node enters the scene tree for the first time.
func _ready():
	_init_variables()


func _process(delta):
	_handle_Like_DisLike_Number_changed()


func _init_variables():
	like_button = $"Nine/Base-M/Base-C/Rating-Center/Rating-C/Rating-M/Like-C/Like_Button"
	dislike_button = $"Nine/Base-M/Base-C/Rating-Center/Rating-C/DisLike-M/DisLike-C/DisLike_Button"
	like_count_label = $"Nine/Base-M/Base-C/Rating-Center/Rating-C/Rating-M/Like-C/Like_Number"
	dislike_count_label = $"Nine/Base-M/Base-C/Rating-Center/Rating-C/DisLike-M/DisLike-C/DisLike_Number"


# Handle Editor Variables
func _set_Title(title):
	$"Nine/Base-M/Base-C/Title-C/Title-Center/Title".text = title


func _set_Body_Text(body_text):
	$"Nine/Base-M/Base-C/Body-M/Body-C/Scroll-C/Text_Body".text = body_text


func _set_Blog_URL(url):
	if(url.empty()):
		$"Nine/Base-M/Base-C/Body-M/Body-C/Button-M/Button_C/Block-M/Blog_Button".visible = false
	else:
		$"Nine/Base-M/Base-C/Body-M/Body-C/Button-M/Button_C/Block-M/Blog_Button".visible = true
		blog_url = url


func _set_Video_URL(url):
	if(url.empty()):
		$"Nine/Base-M/Base-C/Body-M/Body-C/Button-M/Button_C/Video-M/Video_Button".visible = false
	else:
		$"Nine/Base-M/Base-C/Body-M/Body-C/Button-M/Button_C/Video-M/Video_Button".visible = true
		video_url = url


func _handle_Like_DisLike_Number_changed():
	_handle_Like_Number_Changed()
	_handle_DisLike_Number_Changed()


func _handle_Like_Number_Changed():
	like_count_label.text = str(like)


func _handle_DisLike_Number_Changed():
	dislike_count_label.text = str(dislike)


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
	
	if like_pressed:
		# Handle Optic
		_change_Button_and_Label(like_button, like_normal_texture, like_count_label, grey_color)
		# Handle logic
		like -= 1
		emit_signal("like_pressed", like)
		like_pressed = false
	else:
		# Handle Optic
		_change_Button_and_Label(like_button, like_pressed_texture, like_count_label, like_color)
		# Handle logic
		like += 1
		emit_signal("like_pressed", like)
		like_pressed = true
		# Handle Like pressed deactivating DisLike
		if dislike_pressed:
			# Handle Optic
			_change_Button_and_Label(dislike_button, dislike_normal_texture, dislike_count_label, grey_color)
			# Handle logic
			dislike -= 1
			emit_signal("dislike_pressed", dislike)
			dislike_pressed = false
	
	_handle_Like_DisLike_Number_changed()


func _on_DisLike_Button_pressed():
	print("DisLike Button pressed.")
	
	if dislike_pressed:
		# Handle Optic
		_change_Button_and_Label(dislike_button, dislike_normal_texture, dislike_count_label, grey_color)
		# Handle logic
		dislike -= 1
		emit_signal("dislike_pressed", dislike)
		dislike_pressed = false
	else:
		# Handle Optic
		_change_Button_and_Label(dislike_button, dislike_pressed_texture, dislike_count_label, dislike_color)
		# Handle logic
		dislike += 1
		emit_signal("dislike_pressed", dislike)
		dislike_pressed = true
		# Handle DisLike pressed deactivates Like
		if like_pressed:
			# Handle Optic
			_change_Button_and_Label(like_button, like_normal_texture, like_count_label, grey_color)
			# Handle logic
			like -= 1
			emit_signal("like_pressed", like)
			like_pressed = false

	_handle_Like_DisLike_Number_changed()


# Handle visibility of Tool-Tip PopUp 
func _on_PopUp_mouse_entered():
	mouse_hovered = true
	#print("entered: ", mouse_hovered)


func _on_PopUp_mouse_exited():
	if(_should_PopUp_hide()):
		mouse_hovered = false
		#print("exited: ", mouse_hovered)


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


# Helper functions:
func _change_Button_and_Label(button : TextureButton, texture : Texture, label : Label, label_color : Color):
	button.set_normal_texture(texture)
	label.add_color_override("font_color", label_color)
