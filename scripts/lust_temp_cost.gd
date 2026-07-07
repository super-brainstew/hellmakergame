extends Label

var hell_layer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hell_layer = DataManager.layers[0]
	hell_layer.heat_lvl_cost_changed.connect(_on_lust_layer_heat_lvl_next_cost_changed)

func _on_lust_layer_heat_lvl_next_cost_changed(new_amount: Variant) -> void:
	if new_amount == 0:
		text = "MAX"
	else:
		text = str(new_amount)
