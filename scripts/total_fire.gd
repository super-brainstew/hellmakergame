extends Label


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	DataManager.fire_changed.connect(_on_data_manager_fire_changed)

func _on_data_manager_fire_changed(new_amount):
	text = str(new_amount)
