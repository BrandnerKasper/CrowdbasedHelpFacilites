tool
extends EditorPlugin

# Handles the initialization and deletion of the Community ToD plugin

const ToD = preload("res://addons/Community_ToD/scenes/ToD.tscn")
const Upload_ToD = preload("res://addons/Community_ToD/scenes/Upload_ToD.tscn")
const Icon = preload("res://addons/Community_ToD/cloud.svg")

var toD_instance
var upload_tod_instance
var community_ToD_Viewport


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


func _init_ToD():
	toD_instance = ToD.instance()
	community_ToD_Viewport = get_editor_interface().get_editor_viewport().add_child(toD_instance)
	toD_instance.connect("change_to_upload", self, "test_upload_button")
	toD_instance.visible = false


func test_upload_button():
	print("reacting to upload button from ToD scene")
	toD_instance.visible = false
	upload_tod_instance.visible = true
	

func _init_Upload_ToD():
	upload_tod_instance = Upload_ToD.instance()
	community_ToD_Viewport = get_editor_interface().get_editor_viewport().add_child(upload_tod_instance)
	upload_tod_instance.connect("close_Button_pressed", self, "test_close_button")
	upload_tod_instance.visible = false


func test_close_button():
	print("reacting to close Button from Upload ToD scene")
	upload_tod_instance.visible = false
	toD_instance.visible = true
