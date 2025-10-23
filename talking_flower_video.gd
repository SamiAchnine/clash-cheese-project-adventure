extends Node

@export var text_box_path: NodePath
@onready var talk_player: VideoStreamPlayer = $TalkingFlowerTalkPlayer
@onready var idle_player: VideoStreamPlayer = $TalkingFlowerIdlePlayer

func _ready():
	var text_box = get_node_or_null(text_box_path)
	if not text_box:
		push_error("talking_flower_video.gd: Missing text_box_path reference!")
		return

	# Connect signals
	text_box.connect("typing_started", Callable(self, "_on_typing_started"))
	text_box.connect("typing_finished", Callable(self, "_on_typing_finished"))

	# Loop and start idle
	talk_player.loop = true
	idle_player.loop = true
	_play_idle()

func _play_talk():
	if idle_player.is_playing():
		idle_player.stop()
	if not talk_player.is_playing():
		talk_player.play()

func _play_idle():
	if talk_player.is_playing():
		talk_player.stop()
	if not idle_player.is_playing():
		idle_player.play()

func _on_typing_started():
	_play_talk()

func _on_typing_finished():
	_play_idle()
