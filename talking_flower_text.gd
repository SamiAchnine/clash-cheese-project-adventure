extends Control

signal typing_started
signal typing_finished

@onready var text_label = $Label
@export var typing_speed := 0.03
var typing := false

func type_text(text: String) -> void:
	# Emit signal BEFORE typing starts
	emit_signal("typing_started")
	typing = true
	text_label.text = ""

	for i in range(text.length()):
		text_label.text = text.substr(0, i + 1)
		await get_tree().create_timer(typing_speed).timeout
		if not typing:
			break

	# Finish typing
	text_label.text = text
	typing = false
	emit_signal("typing_finished")

# Optional manual skip input
func _input(event):
	if event.is_action_pressed("ui_accept") and typing:
		typing = false
