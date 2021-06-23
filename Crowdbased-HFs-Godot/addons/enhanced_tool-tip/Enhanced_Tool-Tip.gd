extends Control

onready var tool_tip = preload("res://addons/enhanced_tool-tip/PopUp.tscn") 

# Editor variables
export(String, MULTILINE) var body_text = ""
export var blog_button_url = "http://godotengine.org"
export var video_button_url = "https://www.youtube.com/watch?v=42HKCFf5Lf4"

# Variables
var tool_tip_instance
var show = false
var dict : Dictionary
var parent_name : String
var like_count = 0
var dislike_count = 0
var project_name : String
var table_Name : String

# SQLite Database
const SQLite = preload("res://addons/godot-sqlite/bin/gdsqlite.gdns")
var db
var db_name = "res://data/Enhanced_Tool-Tips"


func _enter_tree():
	_handle_init_of_tool_tip_in_database()

# Initialize tool-tip position and content
func _ready():
	var _mouse_entered = self.connect("mouse_entered", self, "_on_Control_mouse_entered")
	var _mouse_exited = self.connect("mouse_exited", self, "_on_Control_mouse_exited")
	self.set_anchors_and_margins_preset(PRESET_WIDE)
	_init_tool_tip()
	_set_tool_tip_variables()


func _init_tool_tip():
	tool_tip_instance = tool_tip.instance()
	add_child(tool_tip_instance)
	tool_tip_instance.connect("like_pressed", self, "_handle_like_pressed")
	tool_tip_instance.connect("dislike_pressed", self, "_handle_dislike_pressed")


func _set_tool_tip_variables():
	tool_tip_instance._set_Title(parent_name)
	# Use the Editor Description of the parent node if there is one
	if(body_text.empty()):
		body_text = get_parent().editor_description
	tool_tip_instance._set_Body_Text(body_text)
	tool_tip_instance._set_Blog_URL(blog_button_url)
	tool_tip_instance._set_Video_URL(video_button_url)
	
	tool_tip_instance.like = like_count
	tool_tip_instance.dislike = dislike_count


# Handle visibility of tool-tip
func _process(_delta):
	if(tool_tip_instance.mouse_hovered or show):
		#print("tool: ",  tool_tip_instance.mouse_hovered)
		yield(get_tree().create_timer(0.7), "timeout")
		if has_node("PopUp"):
			$"PopUp".show()
	else:
		yield(get_tree().create_timer(0.3), "timeout")
		if has_node("PopUp"):
			$"PopUp".hide()


func _on_Control_mouse_entered():
	tool_tip_instance.rect_position = get_global_mouse_position()
	show = true


func _on_Control_mouse_exited():
	show = false


# Database Communication
func _handle_init_of_tool_tip_in_database():
	# Get name of Tip and Database!
	parent_name = get_parent().get_name()
	project_name = ProjectSettings.get("application/config/name")
	
	# Open database
	db = SQLite.new()
	db.path = db_name
	table_Name = project_name
	db.open_db()
	
	if check_Table_exists():
		# If table exists check tip exists
		if check_Tip_exists():
			_set_Like_Dislike_from_Table()
		else:
			_add_Tip_to_Table()
	
	else:
		_create_Table()
		_add_Tip_to_Table()


func check_Table_exists():
	db.query("SELECT name FROM sqlite_master WHERE type='table' AND name = " + "\"" + table_Name + "\"")
	if db.query_result.size() == 0:
		return false
	else:
		return true


func check_Tip_exists():
	# Query to check if Tip is already present!
	var select_condition : String = "Title = \"" + parent_name + "\""
	var selected_array : Array = db.select_rows(table_Name, select_condition, ["Title", "Like_Count", "DisLike_Count"])
	
	if selected_array.size() == 0:
		return false
	else:
		return true


func _set_Like_Dislike_from_Table():
	var select_condition : String = "Title = \"" + parent_name + "\""
	var selected_array : Array = db.select_rows(table_Name, select_condition, ["Title", "Like_Count", "DisLike_Count"])
	like_count = selected_array[0]["Like_Count"]
	dislike_count = selected_array[0]["DisLike_Count"]


func _add_Tip_to_Table():
	# Add Tip to database
	dict["Title"] = parent_name
	dict["Like_Count"] = 0
	dict["DisLike_Count"] = 0
	
	# Add tool tip to database
	db.insert_row(table_Name, dict)


func _create_Table():
	# Seems to make Errors sometime!! Please look into at later point!!
	# Make a big table containing the variable types.
	var table_dict : Dictionary = Dictionary()
	table_dict["Tool-Tip_ID"] = {"data_type":"int", "primary_key": true, "not_null": true}
	table_dict["Title"] = {"data_type":"text", "not_null": true}
	table_dict["Like_Count"] = {"data_type":"int"}
	table_dict["DisLike_Count"] = {"data_type":"int"}
	
	# Create a table with the structure found in table_dict and add it to the database
	db.drop_table(table_Name)
	db.create_table(table_Name, table_dict)


func _handle_like_pressed(like_count : int):
	db = SQLite.new()
	db.path = db_name
	db.open_db()
	# Update Like Count of given entry in database
	db.query("UPDATE " + project_name + " SET Like_Count = " + str(like_count) + " WHERE Title = \"" + parent_name + "\"")


func _handle_dislike_pressed(dislike_count : int):
	db = SQLite.new()
	db.path = db_name
	db.open_db()
	# Update DisLike Count of given entry in database
	db.query("UPDATE " + project_name + " SET DisLike_Count = " + str(dislike_count) + " WHERE Title = \"" + parent_name + "\"")
