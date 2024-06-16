extends CanvasLayer

@onready var close_btn: Button = $Screen/Box/VerticalAlign/ReturnMargin/ReturnButton
@onready var fullscren_btn: CheckButton = $Screen/Box/VerticalAlign/HorizontalAlign/OptionButton
@onready var config: GlobalConfig = GlobalConfig

var video_config: Dictionary
var pressed: bool

func _ready() -> void:
	video_config = config.load_video_settings()
	pressed = video_config.fullscreen
	fullscren_btn.focus_mode = Control.FOCUS_NONE
	
	if (pressed):
		fullscren_btn.set_pressed_no_signal(true)
		
func _process(_delta) -> void:
	var mode
	if (pressed):
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		mode = DisplayServer.WINDOW_MODE_FULLSCREEN
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		mode = DisplayServer.WINDOW_MODE_WINDOWED
		
	config.save_video_settings("window_mode", mode)
	
	if (mode == DisplayServer.WINDOW_MODE_WINDOWED):
		DisplayServer.window_set_size(video_config.resolution)

func _on_return_button_pressed() -> void:
	self.queue_free()


func _on_option_button_pressed() -> void:
	pressed = !pressed
	fullscren_btn.button_pressed = pressed
	config.save_video_settings("fullscreen", pressed)
