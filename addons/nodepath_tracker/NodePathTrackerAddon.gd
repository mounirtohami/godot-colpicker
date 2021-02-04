tool
extends EditorPlugin

var button_scene = preload("NodePathTrackerMenuButton.tscn")
var nodepath_tracker_gd = preload("NodePathTracker.gd")
var nodepath_tracker_icon = preload("nodepath_tracker_icon.png")

var nodepath_tracker_button = null
var last_tracker_selected = null

func _enter_tree():
	add_custom_type("NodePathTracker", "Node", nodepath_tracker_gd, nodepath_tracker_icon)
	nodepath_tracker_button = button_scene.instance()
	add_control_to_container(EditorPlugin.CONTAINER_PROPERTY_EDITOR_BOTTOM, nodepath_tracker_button)
	nodepath_tracker_button.connect("pressed", self, "_on_nodepath_button_pressed")
	nodepath_tracker_button.hide()

func handles(object):
	var is_nodepath_tracker = object is NodePathTracker
	
	if is_nodepath_tracker:
		nodepath_tracker_button.show()
		last_tracker_selected = object as NodePathTracker
	else:
		nodepath_tracker_button.hide()
	
	return is_nodepath_tracker

func clear():
	nodepath_tracker_button.hide()

func make_visible(visible):
	nodepath_tracker_button.visible = visible

func _on_nodepath_button_pressed():
	var check_ok = last_tracker_selected.check_sanity()
	if (check_ok): nodepath_tracker_button.show_ok()
	else: nodepath_tracker_button.show_error()

func _exit_tree():
	if (nodepath_tracker_button):
		remove_control_from_container(EditorPlugin.CONTAINER_CANVAS_EDITOR_MENU, nodepath_tracker_button)
		nodepath_tracker_button.queue_free()
	remove_custom_type("NodePathTracker")
