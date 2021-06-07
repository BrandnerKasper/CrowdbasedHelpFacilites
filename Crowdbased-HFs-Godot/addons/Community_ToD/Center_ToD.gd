tool
extends Control

# SQLite Database
const SQLite = preload("res://addons/godot-sqlite/bin/gdsqlite.gdns")
var db
var db_name = "res://data/Community_ToD"

var tod_list : Array
var tod : Dictionary
var counter = 0

# ToD variables
#var title
var blog_url : String
var video_url : String

func _ready():
	#var unix = OS.get_unix_time()
	#print("Unix Time right know is: " + str(unix))
	
	#commit_Data_to_DB()
	tod_list = get_List_of_ToDs()
	rank_List_of_ToDs()
	get_ToD()
	set_ToD()
	#read_from_DB()
	#set_Title(ToD[2]["Title"])
	#set_Body_Text(ToD[2]["Body_Text"])
	#set_Blog_URL(ToD[2]["Blog_URL"])
	#set_Video_URL(ToD[2]["Video_URL"])
	#set_Like_Count(ToD[2]["Like_Count"])
	#set_Dislike_Count(ToD[2]["DisLike_Count"])
	pass

func commit_Data_to_DB():
	db = SQLite.new()
	db.path = db_name
	db.open_db()
	var tableName = "ToD"
	var dict : Dictionary = Dictionary()
	dict["Title"] = "Test Title"
	dict["Body_Text"] = "Test Body"
	dict["Blog_URL"] = "https://github.com/2shady4u/godot-sqlite"
	dict["Video_URL"] = "https://www.youtube.com/watch?v=HG-PV4rlzoY"
	dict["Like_Count"] = 123
	dict["DisLike_Count"] = 3
	db.insert_row(tableName, dict)

func read_from_DB():
	db = SQLite.new()
	db.path = db_name
	db.open_db()
	var tableName = "SQLiteTable"
	db.query("select * from " + tableName + ";")
	tod_list = db.query_result


func get_List_of_ToDs():
	db = SQLite.new()
	db.path = db_name
	db.open_db()
	db.query("SELECT ToD.Title as Title, ToD.Body_Text as Body, ToD.Blog_URL as Blog, ToD.Video_URL as Video," +
				"ToD.Like_Count as Like, ToD.DisLike_Count as DisLike, ToD.Unix_Timestamp as Timestamp from ToD")
	return db.query_result


func get_ToD():
	#sort tod_list by algo!
	tod = tod_list[counter]


func rank_List_of_ToDs():
	#calculate score for every tip in List of ToDs
	var current_unix_time = OS.get_unix_time()
	for i in range(0, tod_list.size()):
		var time_stamp_in_days = ((current_unix_time - tod_list[i].Timestamp) / 3600) / 24
		var votes = tod_list[i].Like - tod_list[i].DisLike
		var score = votes - time_stamp_in_days
		tod_list[i]["Score"] = score

	#sort Array tod_list
	tod_list.sort_custom(self, "rank_ToDs")
	pass


func rank_ToDs(tip_1 : Dictionary, tip_2 : Dictionary):
	if(tip_1["Score"] > tip_2["Score"]):
		return true
	return false


func set_ToD():
	set_Title(tod["Title"])
	set_Body_Text(tod["Body"])
	set_Blog_URL(tod["Blog"])
	set_Video_URL(tod["Video"])
	set_Like_Count(tod["Like"])
	set_Dislike_Count(tod["DisLike"])


# Set ToD variables
func set_Title(title):
	$"Outer_Rect/Inner_Rect/Inner_M/Body_C/Title_C/Title".text = title


func set_Body_Text(body_text):
	$"Outer_Rect/Inner_Rect/Inner_M/Body_C/Text_C/ScrollContainer/Text_M/Text".text = body_text


func set_Blog_URL(url):
	if(url.empty()):
		$"Outer_Rect/Inner_Rect/Inner_M/Body_C/Text_C/Button_M/Button_C/Block_M/Block_Button".visible = false
	else:
		$"Outer_Rect/Inner_Rect/Inner_M/Body_C/Text_C/Button_M/Button_C/Block_M/Block_Button".visible = true
		blog_url = url


func set_Video_URL(url):
	if(url.empty()):
		$"Outer_Rect/Inner_Rect/Inner_M/Body_C/Text_C/Button_M/Button_C/Video_M/Video_Button".visible = false
	else:
		$"Outer_Rect/Inner_Rect/Inner_M/Body_C/Text_C/Button_M/Button_C/Video_M/Video_Button".visible = true
		video_url = url


func set_Like_Count(like):
	$"Outer_Rect/Inner_Rect/Inner_M/Body_C/Down_M/Down_C/Like_DisLike_M/Like_DisLike_C/Like_M/Like_C/C_L/Label".text = str(like)

func set_Dislike_Count(dislike):
	$"Outer_Rect/Inner_Rect/Inner_M/Body_C/Down_M/Down_C/Like_DisLike_M/Like_DisLike_C/DisLike_M/DisLike_C/C_D/DisLike_L".text = str(dislike)


# Buttons
func _on_X_Button_pressed():
	print("X Button pressed")


func _on_Block_Button_pressed():
	print("Blog Button pressed")
	print("Blog Button pressed.")
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


func _on_Close_Button_pressed():
	print("Close Button pressed")
