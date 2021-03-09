extends ColorPicker

onready var col = ColorRect.new()
onready var _checker = ColorRect.new()
var picking_color := false
var col_backup := Color.black

func _ready() -> void:
	presets_enabled = false
	presets_visible = false
	get_child(0).hide()
	var child4 = get_child(4)
	var child4_4 = get_child(4).get_child(4)
	get_child(3).hide()
	child4_4.get_child(0).hide()
	var popup_menu = child4_4.get_child(3).get_child(1) as PopupMenu
	for i in range(8, 2, -1):
		popup_menu.remove_item(i)
	get_child(1).hide()
	child4_4.get_child(1).hide()
	for i in range(4):
		var line_edit = child4.get_child(i).get_child(2).get_child(0)
		line_edit.context_menu_enabled = false
		line_edit.caret_blink = true
		line_edit.caret_blink_speed = 0.5
		line_edit.focus_mode = Control.FOCUS_CLICK
	for i in range(3):
		var h_slider = child4.get_child(i).get_child(1)
		h_slider.margin_right = 160
	for i in range(4):
		var rgba_label = child4.get_child(i).get_child(0)
		rgba_label.rect_min_size.x = 20
	for i in range(4):
		var spin_box = child4.get_child(i).get_child(2)
		spin_box.align = 1
		spin_box.rect_min_size.x = 35
		spin_box.connect('gui_input', self , '_on_spinbox_gui_input', [spin_box.get_child(0)])
	var hex_line_edit = child4_4.get_child(3)
	hex_line_edit.size_flags_horizontal = 0
	hex_line_edit.align = 1
	hex_line_edit.add_constant_override('minimum_spaces',20)
	hex_line_edit.rect_min_size = Vector2(60, 25)
	hex_line_edit.rect_min_size.x = 120
	hex_line_edit.caret_blink = true
	hex_line_edit.caret_blink_speed = 0.5
	var hsv_check_button = child4_4.get_child(0)
	hsv_check_button.enabled_focus_mode = 0
	hsv_check_button.align = 1
	rect_size = Vector2(100,100)
	child4_4.get_child(3).rect_min_size = Vector2.ZERO
	var hsv_button := Button.new()
	hsv_button.toggle_mode = true
	hsv_button.connect('toggled', self, '_on_hsv_toggled')
	hsv_button.text = "HSV"
	child4_4.add_child(hsv_button)
	child4_4.move_child(hsv_button, 0)
	var margin = MarginContainer.new()
	child4_4.add_child(margin)
	margin.size_flags_horizontal = 3
	margin.add_child(_checker)
	_checker.size_flags_horizontal = 3
	var _mat = preload('./ColPicker.material')
	_checker.material = _mat.duplicate()
	_checker.material.set_shader_param('type', 0)
	_checker.material.set_shader_param('size', Vector2(37,8))
	margin.add_child(col)
	col.color = color
	col.size_flags_horizontal = 3
	child4_4.move_child(margin, 0)
	var picker = Button.new()
	child4_4.add_child(picker)
	picker.text = "Pick"
	picker.connect('pressed', self , "_on_picker_pressed")
	connect('color_changed', self, "_on_col_change")
	set_physics_process(false)
	connect('popup_hide', self , '_on_hide')
	
func _on_hide()-> void:
	var focus_owner = get_focus_owner()
	if focus_owner != null:
		focus_owner.focus_mode = Control.FOCUS_NONE
		focus_owner.focus_mode = Control.FOCUS_CLICK



func _on_picker_pressed()-> void:
	picking_color = true
	set_physics_process(true)
	col_backup = color
	get_child(1).get_child(1).emit_signal('pressed')


func _physics_process(_delta: float) -> void:
	col.color = color


func _on_hsv_toggled(pressed : bool)-> void:
	hsv_mode = pressed

func _on_col_change(_color : Color)-> void:
	col.color = _color

func _on_spinbox_gui_input(event: InputEvent, line_edit : LineEdit):
	if !event is InputEventMouseButton:
		return
	if !event.button_index == BUTTON_RIGHT:
		return
	line_edit.editable = false if event.is_pressed() else true

func _input(event: InputEvent) -> void:
	if !picking_color:
		return
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT || event.button_index == BUTTON_RIGHT:
			if !event.is_pressed():
				set_physics_process(false)
				picking_color = false
				if event.button_index == BUTTON_RIGHT:
					color = col_backup
					var ev = InputEventMouseButton.new()
					ev.button_index = BUTTON_LEFT
					Input.parse_input_event(ev)
	if event is InputEventKey && event.is_pressed():
		if Input.is_key_pressed(KEY_ENTER) || Input.is_key_pressed(KEY_KP_ENTER):
			if get_focus_owner() != null:
				var focus_owner = get_focus_owner()
				focus_owner.focus_mode = Control.FOCUS_NONE
				focus_owner.focus_mode = Control.FOCUS_CLICK
