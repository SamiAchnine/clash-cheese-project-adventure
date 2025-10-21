# Entire script written by GPT. Some modifications were made by me (sami).
extends CanvasLayer

@onready var text_label = $TextBox/VBoxContainer/TextLabel
@onready var next_button = $TextBox/VBoxContainer/NextButton
@onready var choices_container = $TextBox/VBoxContainer/ChoicesContainer

# STORY DATA
# Each "node" of the story has an id, text, and optional choices that lead to another id.
var story = {}

@export var current_node_id = "start"
var typing = false   # prevents overlapping input while typing
@export var typing_speed = 0.01 # seconds per character (higher is slower)

func _ready():
	next_button.pressed.connect(_on_next_pressed)
	load_story("res://story.json")
	display_node(current_node_id)
	
func _input(event):
	if event.is_action_pressed("ui_accept") and typing:
		typing = false
		_show_choices_or_next()


func display_node(node_id: String):
	current_node_id = node_id
	var node_data = story[node_id]
	# Clear UI
	for child in choices_container.get_children():
		child.queue_free()
		
	next_button.visible = false
	text_label.text = ""

	type_text(node_data["text"])

func _show_choices_or_next():
	var node_data = story[current_node_id]
	# Remove any existing choices (optional safety)
	for child in choices_container.get_children():
		child.queue_free()
		
	if "choices" in node_data:
		for choice in node_data["choices"]:
			var btn = Button.new()
			btn.text = choice["text"]
			btn.pressed.connect(func(): on_choice_selected(choice["next"]))
			choices_container.add_child(btn)
	else:
		next_button.visible = true
		if "next" in node_data:
			next_button.disabled = false
		else:
			next_button.text = "End"
			next_button.disabled = true


# TYPEWRITER EFFECT
func type_text(full_text: String) -> void:
	typing = true
	text_label.text = ""
	for i in range(full_text.length()):
		text_label.text = full_text.substr(0, i + 1)
		await get_tree().create_timer(typing_speed).timeout
		if not typing:
			break
			
	text_label.text = full_text
	typing = false
	_show_choices_or_next()


func _on_next_pressed():
	# Skip if typing
	if typing:
		typing = false
		return
	var node_data = story[current_node_id]
	if "next" in node_data:
		display_node(node_data["next"])
	else:
		text_label.text = "The End."

func on_choice_selected(next_node: String):
	display_node(next_node)

func load_story(path: String):
	var file = FileAccess.open(path, FileAccess.READ)
	if file:
		var content = file.get_as_text()
		var json_result = JSON.parse_string(content)
		if typeof(json_result) == TYPE_DICTIONARY:
			story = json_result
		else:
			push_error("Error parsing JSON file: %s" % path)
	else:
		push_error("Could not open story file: %s" % path)
