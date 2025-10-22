extends Button

@onready var mat: ShaderMaterial = material

func _ready():
	connect("mouse_entered", Callable(self, "_on_hover_start"))
	connect("mouse_exited", Callable(self, "_on_hover_end"))
	mat.set_shader_parameter("amplitude", 0.0)

func _on_hover_start():
	var tween = create_tween()
	tween.tween_property(mat, "shader_parameter/amplitude", 5.0, 0.3).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)

func _on_hover_end():
	var tween = create_tween()
	tween.tween_property(mat, "shader_parameter/amplitude", 0.0, 0.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	
func set_pivot_offset_center():
	if self is Control:
		self.pivot_offset = self.size / 2
