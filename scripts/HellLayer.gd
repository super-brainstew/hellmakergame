extends Node
class_name HellLayer

#signals

signal heat_lvl_changed(new_level)
signal heat_lvl_cost_changed(new_amount)
signal heat_lvl_next_cost_changed(new_amount)

signal soul_gen_rate_changed(new_amount)
signal souls_per_layer_changed(new_amount)

#per layer var
var layer_unlocked: bool = false

@export var layer_name: String
@export var progress_bar : ProgressBar
@export var temp_cost_text: Label
@export var souls_per_sec_text: Label
@export var heat_temp_button: TextureButton
@export var ticker: TextureProgressBar

@export var decay_timer: Timer
@export var souls_regen_timer: Timer
@export var tick_rate: float

#heat_lvl
var heat_lvl: int = 0:
	set(value):
		heat_lvl = value
		heat_lvl = clamp(value, 0, 5)
		heat_lvl_changed.emit(value)

@export var heat_lvl_cost_base_rate: int = 0

@export var heat_lvl_cost: int = 0:
	set(value):
		heat_lvl_cost = value
		heat_lvl_cost_changed.emit(value)

@export var heat_lvl_next_cost: int = 0:
	set(value):
		heat_lvl_next_cost = value
		heat_lvl_next_cost_changed.emit(value)

#souls
var souls: int = 0:
	set(value):
		souls = value
		souls_per_layer_changed.emit(value)

@export var max_souls: int = 0

@export var soul_gen_base_rate: int = 0

@export var soul_gen_rate: int = 0:
	set(value):
		soul_gen_rate = value
		soul_gen_rate_changed.emit(value)
