tool
extends Control

# Initializes a Community Tip of the Day (ToD) that fills the generic UI scene with tips from a database file

# Handles scene transistion
signal upload_button_pressed
signal close_pressed

# Community ToD variables
var tod_list : Array
var tod : Dictionary
var counter = 0

# ToD UI variables
var blog_url : String
var video_url : String

func _ready():
	call_deferred("_init_ToD")


func _init_ToD():
	rank_List_of_ToDs()
	get_ToD()
	set_ToD()


func rank_List_of_ToDs():
	#calculate score for every tip in List of ToDs
	calculate_Score_for_ToDs()

	#sort Array tod_list
	tod_list.sort_custom(self, "sort_ToDs")


func calculate_Score_for_ToDs():
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


func get_ToD():
	tod = tod_list[counter]


func set_ToD():
	set_Title(tod["Title"])
	set_Body_Text(tod["Body_Text"])
	set_Blog_URL(tod["Blog_URL"])
	set_Video_URL(tod["Video_URL"])
	set_Like_Count(tod["Like_Count"])
	set_Dislike_Count(tod["DisLike_Count"])


# Set ToD variables
func set_Title(title : String):
	$"Outer_Rect/Inner_Rect/Inner_M/Body_C/Title_C/Title".text = title


func set_Body_Text(body_text : String):
	$"Outer_Rect/Inner_Rect/Inner_M/Body_C/Text_C/ScrollContainer/Text_M/Text".text = body_text


func set_Blog_URL(url : String):
	if(url.empty()):
		$"Outer_Rect/Inner_Rect/Inner_M/Body_C/Text_C/Button_M/Button_C/Block_M/Block_Button".visible = false
	else:
		$"Outer_Rect/Inner_Rect/Inner_M/Body_C/Text_C/Button_M/Button_C/Block_M/Block_Button".visible = true
		blog_url = url


func set_Video_URL(url : String):
	if(url.empty()):
		$"Outer_Rect/Inner_Rect/Inner_M/Body_C/Text_C/Button_M/Button_C/Video_M/Video_Button".visible = false
	else:
		$"Outer_Rect/Inner_Rect/Inner_M/Body_C/Text_C/Button_M/Button_C/Video_M/Video_Button".visible = true
		video_url = url


func set_Like_Count(like : int):
	$"Outer_Rect/Inner_Rect/Inner_M/Body_C/Down_M/Down_C/Like_DisLike_M/Like_DisLike_C/Like_M/Like_C/C_L/Label".text = str(like)


func set_Dislike_Count(dislike : int):
	$"Outer_Rect/Inner_Rect/Inner_M/Body_C/Down_M/Down_C/Like_DisLike_M/Like_DisLike_C/DisLike_M/DisLike_C/C_D/DisLike_L".text = str(dislike)


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
	get_ToD()
	set_ToD()


func _on_Next_Button_pressed():
	print("Next Button pressed")
	if(counter == tod_list.size()-1):
		counter = 0
	else:
		counter += 1
	get_ToD()
	set_ToD()


func _on_Like_Button_pressed():
	print("Like Button pressed")


func _on_DisLike_Button_pressed():
	print("DisLike Button pressed")


func _on_Upload_Button_pressed():
	print("Upload Button pressed")
	emit_signal("upload_button_pressed")


func _on_Close_Button_pressed():
	print("Close Button pressed")
	emit_signal("close_pressed")
