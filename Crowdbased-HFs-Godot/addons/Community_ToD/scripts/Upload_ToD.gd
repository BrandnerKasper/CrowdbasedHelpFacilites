tool
extends Control

# Handles the Upload of a Users tip to the database

# Signals for scene change and upload to database
signal change_scene_pressed
signal upload_Button_pressed(user_tip)


# Upload ToD variables for Database:
var title : String
var body_text : String
var blog_url : String
var video_url : String
var user_tip : Dictionary


# Error Handling for Title and Description Input Lines
var title_edit
var description_edit
var warning_text_color = Color(0.66015625, 0.2421875, 0.2421875)
var warning_text_color_2 = Color(0.99609375, 0.5625, 0.5390625) # Complementary to the green highlight line edit color!
var normal_text_color = Color(0.828125, 0.828125, 0.828125)

# Init line edits
func _ready():
	_init_Line_Edits()


# Handle Line/Text Edits:
# Title Edit
func _on_Title_Edit_focus_entered():
	if !title_edit.text.empty():
		print("Title Warning empty")
		title_edit.add_color_override("font_color", normal_text_color)
		title_edit.text = ""


func _on_Title_Edit_text_entered(new_text):
	title = new_text
	print("Title entered: " + title)


func _on_Title_Edit_focus_exited():
	title = $Outer_Rect/Inner_Rect/Inner_M/Body_C/Upload_C/Title_C/M_T_E/Title_Edit.text
	print("Title entered: " + title)


# Description Edit
func _on_Description_Edit_focus_entered():
	if !description_edit.text.empty():
		print("Description Warning empty")
		description_edit.add_color_override("font_color", normal_text_color)
		description_edit.text = ""


func _on_Description_Edit_focus_exited():
	body_text = $Outer_Rect/Inner_Rect/Inner_M/Body_C/Upload_C/Description_C/M_Txt/Description_Edit.text
	print("Description text entered: " + body_text)


# Blog URL Edit
func _on_Blog_URL_Edit_text_entered(new_text):
	blog_url = new_text
	print("Blog URL entered: " + blog_url)


func _on_Blog_URL_Edit_focus_exited():
	blog_url = $Outer_Rect/Inner_Rect/Inner_M/Body_C/Upload_C/M_B/Blog_URL_C/B_T_E/Blog_URL_Edit.text
	print("Blog URL entered: " + blog_url)


# Video URL Edit
func _on_Video_URL_Edit_text_entered(new_text):
	video_url = new_text
	print("Video URL entered: " + video_url)


func _on_Video_URL_Edit_focus_exited():
	video_url = $Outer_Rect/Inner_Rect/Inner_M/Body_C/Upload_C/M_V/HBoxContainer/V_T_E/Video_URL_Edit.text
	print("Video URL entered: " + video_url)


# Buttons:
func _on_Upload_Button_pressed():
	print("Upload Button pressed")
	if(check_ToD()):
		print("Uploading ToD...")
		_init_user_tip()
		emit_signal("upload_Button_pressed", user_tip)
	else:
		printerr("Please fill in all required fields.")


func _on_Close_Button_pressed():
	print("Close Button pressed")
	emit_signal("change_scene_pressed")


func _on_X_Button_pressed():
	print("X Button pressed")
	emit_signal("change_scene_pressed")


# Helper functions:
func check_ToD():
	if title.empty():
		printerr("Please enter a Title!")
		_show_Warning_on_Title_Edit()
		return false
	if body_text.empty():
		printerr("Please enter a Description!")
		_show_Warning_on_Description_Edit()
		return false
	return true


func _init_user_tip():
	user_tip["Title"] = title
	user_tip["Body_Text"] = body_text
	user_tip["Blog_URL"] = blog_url
	user_tip["Video_URL"] = video_url
	user_tip["Like_Count"] = 0
	user_tip["DisLike_Count"] = 0
	user_tip["Unix_Timestamp"] = OS.get_unix_time()
	user_tip["Engine_Version"] = get_engine_version()


func get_engine_version():
	var engine_version_dict = Engine.get_version_info()
	var engine_version = str(engine_version_dict["major"]) + "." + str(engine_version_dict["minor"]) + "." + str(engine_version_dict["patch"])
	return engine_version


func _init_Line_Edits():
	title_edit = $Outer_Rect/Inner_Rect/Inner_M/Body_C/Upload_C/Title_C/M_T_E/Title_Edit
	description_edit = $Outer_Rect/Inner_Rect/Inner_M/Body_C/Upload_C/Description_C/M_Txt/Description_Edit


func _show_Warning_on_Title_Edit():
	title_edit.text = "Please enter a Title!"
	title_edit.add_color_override("font_color", warning_text_color_2)


func _show_Warning_on_Description_Edit():
	description_edit.text = "Please enter a Description!"
	description_edit.add_color_override("font_color", warning_text_color_2)


func _reset_all_Edits():
	$Outer_Rect/Inner_Rect/Inner_M/Body_C/Upload_C/Title_C/M_T_E/Title_Edit.text = ""
	title = ""
	$Outer_Rect/Inner_Rect/Inner_M/Body_C/Upload_C/Description_C/M_Txt/Description_Edit.text = ""
	body_text = ""
	$Outer_Rect/Inner_Rect/Inner_M/Body_C/Upload_C/M_B/Blog_URL_C/B_T_E/Blog_URL_Edit.text = ""
	blog_url = ""
	$Outer_Rect/Inner_Rect/Inner_M/Body_C/Upload_C/M_V/HBoxContainer/V_T_E/Video_URL_Edit.text = ""
	video_url = ""
