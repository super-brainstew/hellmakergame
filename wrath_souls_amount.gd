extends ProgressBar

var hell_layer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hell_layer = DataManager.layers[4]
	hell_layer.souls_per_layer_changed.connect(_on_greed_layer_souls_per_layer_changed)
	max_value = hell_layer.max_souls
	
func _on_greed_layer_souls_per_layer_changed(new_amount: Variant) -> void:
	value = float(new_amount)
