tool
extends EditorPlugin

# Handles the initialization and deletion of the Community ToD plugin, as well as the database communication

# Scenes and Icon constants
const ToD = preload("res://addons/Community_ToD/scenes/ToD.tscn")
const Upload_ToD = preload("res://addons/Community_ToD/scenes/Upload_ToD.tscn")
const Icon = preload("res://addons/Community_ToD/cloud.svg")

# Instances for Main Screen
var toD_instance
var upload_tod_instance
var community_ToD_Viewport

# SQLite Database
const SQLite = preload("res://addons/godot-sqlite/bin/gdsqlite.gdns")
var db
var db_name = "res://data/Community_ToD"

# Plugin necessity
func _enter_tree():
	call_deferred("_init_ToD")
	call_deferred("_init_Upload_ToD")
	
	make_visible(false)


func _exit_tree():
	if toD_instance:
		toD_instance.queue_free()
	if upload_tod_instance:
		upload_tod_instance.queue_free()


func has_main_screen():
	return true


# make_visible is a virtual function necessary to handle screen transistions
func make_visible(visible):
	if toD_instance:
		toD_instance.visible = visible
	if upload_tod_instance:
		upload_tod_instance.visible = false


func get_plugin_name():
	return "Community ToD"


func get_plugin_icon():
	return Icon
	#return get_editor_interface().get_base_control().get_icon("Node", "EditorIcons")


# Code logic for Tip of the Day scene
func _init_ToD():
	# Set screen
	toD_instance = ToD.instance()
	community_ToD_Viewport = get_editor_interface().get_editor_viewport().add_child(toD_instance)
	
	# Set logic of Tip of the Day scene
	toD_instance.tod_list = _init_List_of_ToDs()
	toD_instance.connect("upload_button_pressed", self, "change_to_upload_scene")
	toD_instance.connect("close_pressed", self, "close_ToD")
	toD_instance.visible = false


func _init_List_of_ToDs():
	db = SQLite.new()
	db.path = db_name
	db.open_db()
	db.query("SELECT ToD.Title as Title, ToD.Body_Text as Body_Text, ToD.Blog_URL as Blog_URL, ToD.Video_URL as Video_URL," +
				"ToD.Like_Count as Like_Count, ToD.DisLike_Count as DisLike_Count, ToD.Unix_Timestamp as Unix_Timestamp," + 
				"ToD.Engine_Version as Engine_Version from ToD")
	return db.query_result


func change_to_upload_scene():
	print("reacting to upload button from ToD scene")
	toD_instance.visible = false
	upload_tod_instance.visible = true


func close_ToD():
	print("reacting to close and x button from ToD scene")
	get_editor_interface().set_plugin_enabled("Community_ToD", false) 


# Code logic for Upload Tip of the Day scene
func _init_Upload_ToD():
	# Set screen
	upload_tod_instance = Upload_ToD.instance()
	community_ToD_Viewport = get_editor_interface().get_editor_viewport().add_child(upload_tod_instance)
	
	# Set logic of Upload Tip of the Day scene
	upload_tod_instance.connect("change_scene_pressed", self, "change_to_tod_scene")
	upload_tod_instance.connect("upload_Button_pressed", self, "handle_upload_tip")
	upload_tod_instance.visible = false


func change_to_tod_scene():
	print("reacting to close Button from Upload ToD scene")
	upload_tod_instance.visible = false
	toD_instance.visible = true


func handle_upload_tip(dict):
	# Add user tip to database
	db = SQLite.new()
	db.path = db_name
	var tableName = "ToD"
	db.open_db()
	db.insert_row(tableName, dict)
	# Update local List of all Tips and change to ToD scene
	update_List_of_ToDs(dict)
	change_to_tod_scene()


func update_List_of_ToDs(dict):
	# Pushes user tip at the top of the dictionary and resets counter to show first entry
	toD_instance.tod_list.push_front(dict)
	toD_instance.counter = 0
	toD_instance.get_ToD()
	toD_instance.set_ToD()
