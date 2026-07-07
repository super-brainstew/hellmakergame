extends Label

var hell_layer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hell_layer = DataManager.layers[3]
	text = str(hell_layer.soul_gen_rate, "/sec")
