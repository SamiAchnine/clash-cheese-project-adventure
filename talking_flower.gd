extends CanvasLayer

@onready var flower_label = $FlowerBox/Label
@onready var talk_player = $TalkingFlowerTalkPlayer
@onready var idle_player = $TalkingFlowerIdlePlayer

@export var text_box_path: NodePath
var text_box: Node

var flower_story = {}
var current_flower_id = ""
var typing = false
@export var typing_speed = 0.02 # seconds per character


func _ready():
	if text_box_path != null:
		text_box = get_node(text_box_path)
	else:
		push_error("talking_flower.gd: Missing text_box_path export assignment!")
		return

	load_flower_story("res://flower_story.json")

	talk_player.loop = true
	idle_player.loop = true

	_play_idle()

	_update_flower_dialogue(text_box.current_node_id)
	set_process(true)


func _process(_delta):
	if text_box and text_box.current_node_id != current_flower_id:
		_update_flower_dialogue(text_box.current_node_id)


func _update_flower_dialogue(node_id: String):
	current_flower_id = node_id

	if not flower_story.has(node_id):
		flower_label.visible = false
		_play_idle()
		return

	flower_label.visible = true
	var flower_text = flower_story[node_id]["text"]

	# Start talk video asynchronously before typing begins
	await _play_talk_async()

	# Run the typewriter effect
	await type_flower_text(flower_text)

	# Return to idle once finished
	_play_idle()


# --- VIDEO CONTROL -----------------------------------------------------------

func _play_talk_async() -> void:
	# Stop idle, then start talk after a frame so decoding starts properly
	if idle_player.is_playing():
		idle_player.stop()
	await get_tree().process_frame
	talk_player.play()
	await get_tree().process_frame


func _play_idle() -> void:
	if talk_player.is_playing():
		talk_player.stop()
	if not idle_player.is_playing():
		idle_player.play()


# --- TYPEWRITER EFFECT -------------------------------------------------------

func type_flower_text(full_text: String) -> void:
	if typing:
		return
	typing = true
	flower_label.text = ""

	for i in range(full_text.length()):
		flower_label.text = full_text.substr(0, i + 1)
		await get_tree().create_timer(typing_speed).timeout
		await get_tree().process_frame  # keeps video rendering smooth
		if not typing:
			break

	flower_label.text = full_text
	typing = false

func load_flower_story(path: String):
	var file = FileAccess.open(path, FileAccess.READ)
	if file:
		var content = file.get_as_text()
		var json_result = JSON.parse_string(content)
		if typeof(json_result) == TYPE_DICTIONARY:
			flower_story = json_result
		else:
			push_error("Error parsing JSON file: %s" % path)
	else:
		push_error("Could not open story file: %s" % path)
		
