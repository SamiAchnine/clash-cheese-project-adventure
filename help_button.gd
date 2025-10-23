extends Button


func _ready():
	self.pressed.connect(_button_pressed)
	
func _button_pressed():
	OS.shell_open("https://www.youtube.com/shorts/HKCzE-OW0zM")
