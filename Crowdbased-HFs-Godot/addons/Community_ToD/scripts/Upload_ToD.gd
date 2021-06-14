tool
extends Control

# Handles the Upload of a Users tip to the database

# Handles scene change
signal close_Button_pressed

# SQLite Database
const SQLite = preload("res://addons/godot-sqlite/bin/gdsqlite.gdns")
var db
var db_name = "res://data/Community_ToD"

# Upload ToD variables for Database:
var title : String
var body_text : String
var blog_url : String
var video_url : String


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
		commit_Data_to_DB()
	else:
		printerr("Please fill in all required fields.")


func _on_Close_Button_pressed():
	print("Close Button pressed")
	emit_signal("close_Button_pressed")


func _on_X_Button_pressed():
	print("X Button pressed")


# Helper functions:
func check_ToD():
	if(title.empty()):
		printerr("Please enter a Title!")
		return false
	if(body_text.empty()):
		printerr("Please enter a Description!")
		return false
	return true


# Send to database
func commit_Data_to_DB():
	db = SQLite.new()
	db.path = db_name
	db.open_db()
	var tableName = "ToD"
	var dict : Dictionary = Dictionary()
	dict["Title"] = title
	dict["Body_Text"] = body_text
	dict["Blog_URL"] = blog_url
	dict["Video_URL"] = video_url
	dict["Like_Count"] = 0
	dict["DisLike_Count"] = 0
	dict["Unix_Timestamp"] = OS.get_unix_time()
	db.insert_row(tableName, dict)
