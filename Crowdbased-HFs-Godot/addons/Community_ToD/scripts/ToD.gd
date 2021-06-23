tool
extends Control

# Initializes a Community Tip of the Day (ToD) that fills the generic UI scene with tips from a database file

# Handles scene transistion
signal upload_button_pressed
signal close_pressed

# Updates Like and DisLike Count
signal like_pressed(vote, title)
signal dislike_pressed(vote, title)

# Community ToD variables
var tod_list : Array
var tod : Dictionary
var counter = 0

# ToD UI variables
var blog_url : String
var video_url : String

# Like / DisLike Handling and mimic Youtube Button behaviour
var like_button
var dislike_button
var like_count_label
var dislike_count_label
var grey_color = Color(0.828125, 0.828125, 0.828125, 1)
var like_color = Color(0.2734375, 0.98828125, 0.515625, 1)
var dislike_color = Color(0.953125, 0.57421875, 0.296875, 1)
var like_pressed = false
const like_normal_texture = preload("res://addons/Community_ToD/textures/Like_Test_01.png")
const like_pressed_texture = preload("res://addons/Community_ToD/textures/Like_Test_03.png")
var dislike_pressed = false
const dislike_normal_texture = preload("res://addons/Community_ToD/textures/DisLike_Test_01.png")
const dislike_pressed_texture = preload("res://addons/Community_ToD/textures/DisLike_Test_03.png")
# Remember all ToDs you liked disliked -.-
var rated_comments : Array # With User Managment this should come from database! for now only locally

func _ready():
	call_deferred("_init_ToD")


func _init_ToD():
	_init_Like_DisLike_Buttons()
	_rank_List_of_ToDs()
	_update_ToD()
	_init_rated_comment_List()


func _init_Like_DisLike_Buttons():
	like_button = $Outer_Rect/Inner_Rect/Inner_M/Body_C/Down_M/Down_C/Like_DisLike_M/Like_DisLike_C/Like_M/Like_C/Like_Button
	dislike_button = $Outer_Rect/Inner_Rect/Inner_M/Body_C/Down_M/Down_C/Like_DisLike_M/Like_DisLike_C/DisLike_M/DisLike_C/DisLike_Button


func _rank_List_of_ToDs():
	#calculate score for every tip in List of ToDs
	_calculate_Score_for_ToDs()

	#sort Array tod_list
	tod_list.sort_custom(self, "sort_ToDs")


func _calculate_Score_for_ToDs():
	var current_unix_time = OS.get_unix_time()
	for i in range(0, tod_list.size()):
		var time_stamp_in_days = ((current_unix_time - tod_list[i].Unix_Timestamp) / 3600) / 24
		var votes = tod_list[i].Like_Count - tod_list[i].DisLike_Count
		var score = votes - time_stamp_in_days
		tod_list[i]["Score"] = score


func sort_ToDs(tip_1 : Dictionary, tip_2 : Dictionary):
	if(tip_1["Score"] > tip_2["Score"]):
		return true
	return false


func _update_ToD():
	if tod_list.size() > 0:
		_get_ToD()
		_set_ToD()


func _get_ToD():
	tod = tod_list[counter]


func _set_ToD():
	_set_ToD_Count()
	_set_Title(tod["Title"])
	_set_Date_Version(tod["Unix_Timestamp"], tod["Engine_Version"])
	_set_Body_Text(tod["Body_Text"])
	_set_Blog_URL(tod["Blog_URL"])
	_set_Video_URL(tod["Video_URL"])
	_set_Like_Count(tod["Like_Count"])
	_set_Dislike_Count(tod["DisLike_Count"])


func _init_rated_comment_List():
	for i in tod_list.size():
		var dict = { "Like": false, "DisLike": false}
		rated_comments.append(dict)


# Set ToD variables
func _set_ToD_Count():
	$Outer_Rect/Top_C/ToD_L.text = "Community Tip of the Day " + "(" + str(counter + 1) + "/" + str(tod_list.size()) + ")"


func _set_Title(title : String):
	$"Outer_Rect/Inner_Rect/Inner_M/Body_C/Title_C/Title".text = title


func _set_Date_Version(timestamp : int, engine_version : String):
	var date_dict = OS.get_datetime_from_unix_time(timestamp)
	var date = str(date_dict["day"]) + "." + str(date_dict["month"]) + "." + str(date_dict["year"])
	
	$Outer_Rect/Inner_Rect/Inner_M/Body_C/Date_Version_M/Date_Version_L.text = str(date) + " (Version " + str(engine_version) + ")"


func _set_Body_Text(body_text : String):
	$"Outer_Rect/Inner_Rect/Inner_M/Body_C/Text_C/ScrollContainer/Text_M/Text".text = body_text


func _set_Blog_URL(url : String):
	if(url.empty()):
		$"Outer_Rect/Inner_Rect/Inner_M/Body_C/Text_C/Button_M/Button_C/Block_M/Block_Button".visible = false
	else:
		$"Outer_Rect/Inner_Rect/Inner_M/Body_C/Text_C/Button_M/Button_C/Block_M/Block_Button".visible = true
		blog_url = url


func _set_Video_URL(url : String):
	if(url.empty()):
		$"Outer_Rect/Inner_Rect/Inner_M/Body_C/Text_C/Button_M/Button_C/Video_M/Video_Button".visible = false
	else:
		$"Outer_Rect/Inner_Rect/Inner_M/Body_C/Text_C/Button_M/Button_C/Video_M/Video_Button".visible = true
		video_url = url


func _set_Like_Count(like : int):
	like_count_label = $"Outer_Rect/Inner_Rect/Inner_M/Body_C/Down_M/Down_C/Like_DisLike_M/Like_DisLike_C/Like_M/Like_C/C_L/Label"
	like_count_label.text = str(like)


func _set_Dislike_Count(dislike : int):
	dislike_count_label = $"Outer_Rect/Inner_Rect/Inner_M/Body_C/Down_M/Down_C/Like_DisLike_M/Like_DisLike_C/DisLike_M/DisLike_C/C_D/DisLike_L"
	dislike_count_label.text = str(dislike)


# Buttons
func _on_X_Button_pressed():
	print("X Button pressed")
	emit_signal("close_pressed")


func _on_Block_Button_pressed():
	print("Blog Button pressed")
	var _open_blog = OS.shell_open(blog_url)
	if(_open_blog != 0):
		print("No valid path")


func _on_Video_Button_pressed():
	print("Video Button pressed")
	var _open_video = OS.shell_open(video_url)
	if(_open_video != 0):
		print("No valid path")


func _on_Prev_Button_pressed():
	print("Prev Button pressed")
	if(counter == 0):
		counter = tod_list.size()-1
	else:
		counter -= 1
	_update_ToD()
	
	_check_Like_DisLike()


func _on_Next_Button_pressed():
	print("Next Button pressed")
	if(counter == tod_list.size()-1):
		counter = 0
	else:
		counter += 1
	_update_ToD()
	
	_check_Like_DisLike()


func _check_Like_DisLike():
	# Remember Tips liked/disliked
	# Reset
	print("Like checked: " + str(rated_comments[counter]["Like"]) + " Dislike checked: " + str(rated_comments[counter]["DisLike"]))
	if !rated_comments[counter]["Like"]:
		_change_Button_and_Label(like_button, like_normal_texture, like_count_label, grey_color)
		like_pressed = false
	else:
		_change_Button_and_Label(like_button, like_pressed_texture, like_count_label, like_color)
		like_pressed = true

	if !rated_comments[counter]["DisLike"]:
		_change_Button_and_Label(dislike_button, dislike_normal_texture, dislike_count_label, grey_color)
		dislike_pressed = false
	else:
		_change_Button_and_Label(dislike_button, dislike_pressed_texture, dislike_count_label, dislike_color)
		dislike_pressed = true


func _on_Like_Button_pressed():
	print("Like Button pressed")
	if like_pressed:
		# Handle Optic
		_change_Button_and_Label(like_button, like_normal_texture, like_count_label, grey_color)
		# Handle logic
		emit_signal("like_pressed", -1, tod_list[counter]["Title"])
		tod_list[counter]["Like_Count"] -= 1
		rated_comments[counter]["Like"] = false 
		like_pressed = false
	else:
		# Handle Optic
		_change_Button_and_Label(like_button, like_pressed_texture, like_count_label, like_color)
		# Handle logic
		emit_signal("like_pressed", 1, tod_list[counter]["Title"])
		tod_list[counter]["Like_Count"] += 1
		like_pressed = true
		rated_comments[counter]["Like"] = true 
		# Handle Like pressed deactivating DisLike
		if dislike_pressed:
			_change_Button_and_Label(dislike_button, dislike_normal_texture, dislike_count_label, grey_color)
			emit_signal("dislike_pressed", -1, tod_list[counter]["Title"])
			tod_list[counter]["DisLike_Count"] -= 1
			rated_comments[counter]["DisLike"] = false 
			dislike_pressed = false
	
	_update_ToD()


func _on_DisLike_Button_pressed():
	print("DisLike Button pressed")
	if dislike_pressed:
		# Handle Optic
		_change_Button_and_Label(dislike_button, dislike_normal_texture, dislike_count_label, grey_color)
		# Handle logic
		emit_signal("dislike_pressed", -1, tod_list[counter]["Title"])
		tod_list[counter]["DisLike_Count"] -= 1
		rated_comments[counter]["DisLike"] = false 
		dislike_pressed = false
	else:
		# Handle Optic
		_change_Button_and_Label(dislike_button, dislike_pressed_texture, dislike_count_label, dislike_color)
		# Handle logic
		emit_signal("dislike_pressed", 1, tod_list[counter]["Title"])
		tod_list[counter]["DisLike_Count"] += 1
		rated_comments[counter]["DisLike"] = true
		dislike_pressed = true
		# Handle DisLike pressed deactivates Like
		if like_pressed:
			_change_Button_and_Label(like_button, like_normal_texture, like_count_label, grey_color)
			emit_signal("like_pressed", -1, tod_list[counter]["Title"])
			tod_list[counter]["Like_Count"] -= 1
			rated_comments[counter]["Like"] = false 
			like_pressed = false
	
	_update_ToD()


func _change_Button_and_Label(button : TextureButton, texture : Texture, label : Label, label_color : Color):
	button.set_normal_texture(texture)
	label.add_color_override("font_color", label_color)


func _on_Upload_Button_pressed():
	print("Upload Button pressed")
	emit_signal("upload_button_pressed")


func _on_Close_Button_pressed():
	print("Close Button pressed")
	emit_signal("close_pressed")
