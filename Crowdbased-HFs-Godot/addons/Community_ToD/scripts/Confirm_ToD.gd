tool
extends Control

# Signals for scene change and upload to database
signal change_scene_pressed
signal confirm_Button_pressed(tod)

# ToD UI variables
var tod : Dictionary

var blog_url : String
var video_url : String


func _set_Confirm_ToD():
	_set_Title(tod["Title"])
	_set_Date_Version(tod["Unix_Timestamp"], tod["Engine_Version"])
	_set_Body_Text(tod["Body_Text"])
	_set_Blog_URL(tod["Blog_URL"])
	_set_Video_URL(tod["Video_URL"])


# Set ToD variables
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


# Buttons
func _on_Block_Button_pressed():
	print("Blog Button pressed")
	if(blog_url.empty()): #redundant delete later!
		return
	var _open_blog = OS.shell_open(blog_url)
	if(_open_blog != 0):
		print("No valid path")


func _on_Video_Button_pressed():
	print("Video Button pressed")
	if(video_url.empty()): #redundant delete later!
		return
	var _open_video = OS.shell_open(video_url)
	if(_open_video != 0):
		print("No valid path")


func _on_X_Button_pressed():
	print("X Button pressed")
	emit_signal("change_scene_pressed")


func _on_Confirm_Button_pressed():
	print("Confirm Button pressed")
	emit_signal("confirm_Button_pressed", tod)


func _on_Close_Button_pressed():
	print("Close Button pressed")
	emit_signal("change_scene_pressed")

