extends Label


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	DataManager.souls_changed.connect(_on_data_manager_souls_changed)

func _on_data_manager_souls_changed(new_amount):
	text = str(new_amount)
	print("label received souls signal: ", new_amount)
