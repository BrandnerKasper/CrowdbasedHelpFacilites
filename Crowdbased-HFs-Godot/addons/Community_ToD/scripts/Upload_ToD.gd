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


# Handle Line/Text Edits:
func _on_Title_Edit_text_entered(new_text):
	title = new_text
	print("Title entered: " + title)


func _on_Title_Edit_focus_exited():
	title = $Outer_Rect/Inner_Rect/Inner_M/Body_C/Upload_C/Title_C/M_T_E/Title_Edit.text
	print("Title entered: " + title)


func _on_Description_Edit_focus_exited():
	body_text = $Outer_Rect/Inner_Rect/Inner_M/Body_C/Upload_C/Description_C/M_Txt/Description_Edit.text
	print("Description text entered: " + body_text)


func _on_Blog_URL_Edit_text_entered(new_text):
	blog_url = new_text
	print("Blog URL entered: " + blog_url)


func _on_Blog_URL_Edit_focus_exited():
	blog_url = $Outer_Rect/Inner_Rect/Inner_M/Body_C/Upload_C/M_B/Blog_URL_C/B_T_E/Blog_URL_Edit.text
	print("Blog URL entered: " + blog_url)


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
		#commit_Data_to_DB()
		init_user_tip()
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
	if(title.empty()):
		printerr("Please enter a Title!")
		return false
	if(body_text.empty()):
		printerr("Please enter a Description!")
		return false
	return true

func init_user_tip():
	user_tip["Title"] = title
	user_tip["Body_Text"] = body_text
	user_tip["Blog_URL"] = blog_url
	user_tip["Video_URL"] = video_url
	user_tip["Like_Count"] = 0
	user_tip["DisLike_Count"] = 0
	user_tip["Unix_Timestamp"] = OS.get_unix_time()
