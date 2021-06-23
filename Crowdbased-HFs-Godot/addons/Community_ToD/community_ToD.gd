tool
extends EditorPlugin

# Handles the initialization and deletion of the Community ToD plugin, as well as the database communication

# Scenes and Icon constants
const ToD = preload("res://addons/Community_ToD/scenes/ToD.tscn")
const Upload_ToD = preload("res://addons/Community_ToD/scenes/Upload_ToD.tscn")
const Confirm_ToD = preload("res://addons/Community_ToD/scenes/Confirm_ToD.tscn")
const Icon = preload("res://addons/Community_ToD/cloud.svg")

# Instances for Main Screen
var toD_instance
var upload_tod_instance
var confirm_tod_instance
var community_ToD_Viewport

# SQLite Database
const SQLite = preload("res://addons/godot-sqlite/bin/gdsqlite.gdns")
var db
var db_name = "res://data/Community_ToD"

# Plugin necessity
func _enter_tree():
	call_deferred("_init_ToD")
	call_deferred("_init_Upload_ToD")
	call_deferred("_init_Confirm_ToD")
	
	make_visible(false)


func _exit_tree():
	if toD_instance:
		toD_instance.queue_free()
	if upload_tod_instance:
		upload_tod_instance.queue_free()
	if confirm_tod_instance:
		confirm_tod_instance.queue_free()


func has_main_screen():
	return true


# make_visible is a virtual function necessary to handle screen transistions
func make_visible(visible):
	if toD_instance:
		toD_instance.visible = visible
	if upload_tod_instance:
		upload_tod_instance.visible = false
	if confirm_tod_instance:
		confirm_tod_instance.visible = false


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
	toD_instance.connect("upload_button_pressed", self, "_change_to_upload_scene")
	toD_instance.connect("close_pressed", self, "_close_ToD")
	toD_instance.connect("like_pressed", self, "_handle_like_pressed")
	toD_instance.connect("dislike_pressed", self, "_handle_dislike_pressed")
	toD_instance.visible = false


func _init_List_of_ToDs():
	db = SQLite.new()
	db.path = db_name
	db.open_db()
	db.query("SELECT ToD.Title as Title, ToD.Body_Text as Body_Text, ToD.Blog_URL as Blog_URL, " +  
				"ToD.Video_URL as Video_URL, ToD.Like_Count as Like_Count, ToD.DisLike_Count as DisLike_Count, " + 
				"ToD.Unix_Timestamp as Unix_Timestamp, ToD.Engine_Version as Engine_Version from ToD")
	return db.query_result


func _change_to_upload_scene():
	print("reacting to upload button from ToD scene")
	toD_instance.visible = false
	upload_tod_instance.visible = true


func _close_ToD():
	print("reacting to close and x button from ToD scene")
	get_editor_interface().set_plugin_enabled("Community_ToD", false) 


func _handle_like_pressed(vote, title):
	db = SQLite.new()
	db.path = db_name
	db.open_db()
	db.query("UPDATE ToD SET Like_Count = Like_Count + " + str(vote) + " WHERE Title = " + "\"" + title + "\"")


func _handle_dislike_pressed(vote, title):
	db = SQLite.new()
	db.path = db_name
	db.open_db()
	db.query("UPDATE ToD SET DisLike_Count = DisLike_Count + " + str(vote) + " WHERE Title = " + "\"" + title + "\"")


# Code logic for Upload Tip of the Day scene
func _init_Upload_ToD():
	# Set screen
	upload_tod_instance = Upload_ToD.instance()
	community_ToD_Viewport = get_editor_interface().get_editor_viewport().add_child(upload_tod_instance)
	
	# Set logic of Upload Tip of the Day scene
	upload_tod_instance.connect("change_scene_pressed", self, "_change_to_tod_scene")
	upload_tod_instance.connect("upload_Button_pressed", self, "_handle_upload_tip")
	upload_tod_instance.visible = false


func _change_to_tod_scene():
	print("reacting to close Button from Upload ToD scene")
	upload_tod_instance.visible = false
	toD_instance.visible = true
	
	# Reset Edits of Upload
	upload_tod_instance._reset_all_Edits()


func _handle_upload_tip(dict):
	confirm_tod_instance.tod = dict
	confirm_tod_instance._set_Confirm_ToD()
	
	# Change scene to confirm tod scene
	upload_tod_instance.visible = false
	confirm_tod_instance.visible = true


# Code logic for Confirm Tip of the Day scene
func _init_Confirm_ToD():
	# Set screen
	confirm_tod_instance = Confirm_ToD.instance()
	community_ToD_Viewport = get_editor_interface().get_editor_viewport().add_child(confirm_tod_instance)
	
	# Set logic for Confirm Tip of the Day scene
	confirm_tod_instance.connect("change_scene_pressed", self, "_change_to_upload_tod_scene")
	confirm_tod_instance.connect("confirm_Button_pressed", self, "_handle_confirm_tip")
	confirm_tod_instance.visible = false


func _change_to_upload_tod_scene():
	print("reacting to close Button from Confirm ToD scene")
	confirm_tod_instance.visible = false
	upload_tod_instance.visible = true


func _handle_confirm_tip(dict):
	# Add user tip to database
	db = SQLite.new()
	db.path = db_name
	var tableName = "ToD"
	db.open_db()
	db.insert_row(tableName, dict)
	
	# Update local List of all Tips and change to ToD scene
	_update_List_of_ToDs(dict)
	
	# Change scene
	confirm_tod_instance.visible = false
	toD_instance.visible = true
	
	# Reset Edits of Upload
	upload_tod_instance._reset_all_Edits()


func _update_List_of_ToDs(dict):
	# Pushes user tip at the end of the array and sets counter to show last entry
	toD_instance.tod_list.append(dict)
	# add a local reference
	var ref = { "Like": false, "DisLike": false}
	toD_instance.rated_comments.append(ref)
	toD_instance.counter = toD_instance.tod_list.size() -1
	# TODO: fix last tip is shown twice when multiple tips are uploaded
	toD_instance._check_Like_DisLike()
	toD_instance._get_ToD()
	toD_instance._set_ToD()
