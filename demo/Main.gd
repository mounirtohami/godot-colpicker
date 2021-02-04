extends Control

func _ready():
	for node in $NodePathTracker.get_nodes():
		if node is Button:
			node.connect("pressed", self, "_on_button_pressed", [node])

func _on_button_pressed(button : Button):
	$NodePathTracker.get_node_by_name("PressedLabel").text = "Button " + button.name + " pressed!"
