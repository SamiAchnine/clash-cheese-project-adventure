# Entire script written by GPT. Some modifications were made by me (sami).
extends CanvasLayer

@onready var text_label = $TextBox/VBoxContainer/TextLabel
@onready var next_button = $TextBox/VBoxContainer/NextButton
@onready var choices_container = $TextBox/VBoxContainer/ChoicesContainer

# STORY DATA
# Each "node" of the story has an id, text, and optional choices that lead to another id.
var story = {
	"start": {
		"text": "You wake up in a dark forest. Two paths lie before you.",
		"choices": [
			{"text": "Take the left path", "next": "left_path"},
			{"text": "Take the right path", "next": "right_path"}
			]
		},
	"left_path": {
		"text": "The left path leads you to an ancient ruin. A door stands before you.",
		"choices": [
			{"text": "Enter the ruin", "next": "inside_ruin"},
			{"text": "Go back", "next": "start"}
			]
		},
		"right_path": {
			"text": "You follow the right path and find a calm river. It looks peaceful.",
			"choices": [
				{"text": "Drink from the river", "next": "river_drink"},
				{"text": "Cross the river", "next": "cross_river"}
				]
			},
		"inside_ruin": {
		"text": "Inside, you find a glowing artifact. As you reach out, light fills your vision.",
		"choices":[{"text": "Okay", "next": "end"}]
		},
		"river_drink": {
		"text": "The water is cool and refreshing. You feel renewed.",
		"choices":[{"text": "Okay", "next": "end"}]
		},
		"cross_river": {
			"text": "You cross safely and see a village in the distance. Maybe you’ll find help there.",
			"choices":[{"text": "Okay", "next": "end"}]
			},
		"end": {
		"text": "Your journey for now has ended. The forest whispers your name as you fade away..."
		}
}

var current_node_id = "start"
var typing = false   # prevents overlapping input while typing
var typing_speed = 0.03  # seconds per character (adjust to taste)

func _ready():
	next_button.pressed.connect(_on_next_pressed)
	display_node(current_node_id)

func display_node(node_id: String):
	current_node_id = node_id
	var node_data = story[node_id]
# Clear UI
	for child in choices_container.get_children():
		child.queue_free()
		
	next_button.visible = false
	text_label.text = ""

# Start typewriter animation
	type_text(node_data["text"])
# Setup choices or next
	if "choices" in node_data:
		await get_tree().create_timer(len(node_data["text"]) * typing_speed).timeout
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
