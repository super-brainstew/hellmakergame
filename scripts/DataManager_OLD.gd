extends Node2D

#signals
signal fire_changed(new_amount)
signal souls_changed(new_amount)


signal soul_gen_rate_changed(layer, new_amount)
signal heat_lvl_changed (layer, new_level)

signal heat_lvl_cost_changed(layer, new_amount)
signal heat_lvl_next_cost_changed(layer, new_amount)

signal souls_per_layer_changed(layer, new_amount)

#global ints
var fire: int = 0:
	#when fire int changes, emits a signal to UI elements
	set(value):
		fire = value
		fire_changed.emit(fire)

var global_souls_total = 0:
	set(value):
		global_souls_total = value
		souls_changed.emit(global_souls_total)

#per layer ints
var souls_amount_per_layer: Dictionary = {
	"lust_souls": 0,
	"gluttony_souls": 0,
	"greed_souls": 0,
	"sloth_souls": 0,
	"wrath_souls": 0,
	"envy_souls": 0,
	"pride_souls": 0
}

#is this enum doing anything?
enum Layer {lust, gluttony, greed, sloth, wrath, envy, pride}

var layer_unlocked: Dictionary = {
	"lust": false,
	"gluttony": false,
	"greed": false,
	"sloth": false,
	"wrath": false,
	"envy": false,
	"pride": false
}

var heat_lvl: Dictionary = {
	"lust": 0,
	"gluttony": 0,
	"greed": 0,
	"sloth": 0,
	"wrath": 0,
	"envy": 0,
	"pride": 0
}
	#move the .emit somewhere else
	#set(value):
		#heat_lvl = clamp (value, 0, 5)
		#heat_lvl_changed.emit(heat_lvl)
		

@export var heat_lvl_multi_1 = 1.2
@export var heat_lvl_multi_2 = 1.4
@export var heat_lvl_multi_3 = 1.8
@export var heat_lvl_multi_4 = 2
@export var heat_lvl_multi_5 = 3

@export var heat_lvl_cost: Dictionary = {
	"lust": 100,
	"gluttony": 100,
	"greed": 100,
	"sloth": 100,
	"wrath": 100,
	"envy": 100,
	"pride": 100
}

@export var heat_lvl_cost_base_rate: Dictionary = {
	"lust": 100,
	"gluttony": 100,
	"greed": 100,
	"sloth": 100,
	"wrath": 100,
	"envy": 100,
	"pride": 100
}
@export var heat_lvl_next_cost: Dictionary = {
	"lust": 100,
	"gluttony": 100,
	"greed": 100,
	"sloth": 100,
	"wrath": 100,
	"envy": 100,
	"pride": 100
}

@export var soul_gen_base_rate: Dictionary = {
	"lust": 10,
	"gluttony": 10,
	"greed": 10,
	"sloth": 10,
	"wrath": 10,
	"envy": 10,
	"pride": 10
}

@export var soul_gen_rate: Dictionary = {
	"lust": 10,
	"gluttony": 10,
	"greed": 10,
	"sloth": 10,
	"wrath": 10,
	"envy": 10,
	"pride": 10
}
	#move .emit somewhere else
	#set(value):
		#soul_gen_rate = value
		#soul_gen_rate_changed.emit(soul_gen_rate)

@export var max_souls: Dictionary = {
	"lust": 1000,
	"gluttony": 5000,
	"greed": 20000,
	"sloth": 80000,
	"wrath": 300000,
	"envy": 1000000,
	"pride": 5000000
}

#global vars end here

#cant set() and .emit updating values formatted as var
#so this func is a workaround to capture values that change
#and call them all from one place (put inside of func that
#update automatically or with player input
func emit_layer_state(layer: String) -> void:
	heat_lvl_changed.emit(layer, heat_lvl[layer])
	soul_gen_rate_changed.emit(layer, soul_gen_rate[layer])
	heat_lvl_next_cost_changed.emit(layer, heat_lvl_next_cost[layer])
	souls_per_layer_changed.emit(layer, souls_amount_per_layer[layer + "_souls"])

func sum_all_souls():
	global_souls_total = souls_amount_per_layer["lust_souls"] + souls_amount_per_layer["gluttony_souls"] + souls_amount_per_layer["greed_souls"] + souls_amount_per_layer["sloth_souls"] + souls_amount_per_layer["wrath_souls"] + souls_amount_per_layer["envy_souls"] + souls_amount_per_layer["pride_souls"]
	
#buttons to unlock layers
func _on_unlock_lust_pressed() -> void:
	if fire == 1:
		#commented out the below function, may not need it
		#unlock_layer(layer_unlocked.lust)
		layer_unlocked["lust"] = true
		fire -= 1
		$"../UI/Unlock_Lust".queue_free()
		$"../UI/LustUI".show()
		print("lust unlock working")

#this func may be redundant, moved core functions to on_unlock func right above this
#func unlock_layer(layer):
	#match layer:
		#layer_unlocked.lust:
			#emit_signal("show_layer_lust")
			#print("lust layer active")
			#$"../UI/Unlock_Lust".queue_free()

func _on_souls_regen_timer_timeout() -> void:
	for layer in layer_unlocked:
		if layer_unlocked[layer] == true:
			souls_amount_per_layer[layer + "_souls"] += soul_gen_rate[layer]
			if souls_amount_per_layer[layer + "_souls"] >= max_souls[layer]:
				souls_amount_per_layer[layer + "_souls"] = max_souls[layer]
			souls_per_layer_changed.emit(layer, souls_amount_per_layer[layer + "_souls"])
		
	sum_all_souls()
	emit_layer_state(layer)
	
func convert_souls_to_fire(layer):
	match layer:
		Layer.lust:
			print("lust fire converted")
			fire += souls_amount_per_layer["lust_souls"]
			souls_amount_per_layer["lust_souls"] = souls_amount_per_layer["lust_souls"] - souls_amount_per_layer["lust_souls"]
			

#heat lvl
func _on_lust_temp_pressed() -> void:
	heat_lvl_up("lust")
	print("lust heat up", heat_lvl)
	
func heat_lvl_up(layer):
	if layer == "lust":
		$"../HeatDecayTimer".stop()
		$"../HeatDecayTimer".start()
	#timers need to be replaced with actual timers
	#if layer == "gluttony":
		#$"../HeatDecayTimer".stop()
		#$"../HeatDecayTimer".start()
	#if layer == "sloth":
		#$"../HeatDecayTimer".stop()
		#$"../HeatDecayTimer".start()
	#if layer == "greed":
		#$"../HeatDecayTimer".stop()
		#$"../HeatDecayTimer".start()
	#if layer == "wrath":
		#$"../HeatDecayTimer".stop()
		#$"../HeatDecayTimer".start()
	#if layer == "envy":
		#$"../HeatDecayTimer".stop()
		#$"../HeatDecayTimer".start()
	#if layer == "pride":
		#$"../HeatDecayTimer".stop()
		#$"../HeatDecayTimer".start()
	
	if fire >= heat_lvl_cost[layer]:
		fire -= heat_lvl_cost[layer]
		heat_lvl_cost[layer] += 1
		
	if heat_lvl_cost[layer] == 0:
		soul_gen_rate[layer] = soul_gen_base_rate[layer] 
		heat_lvl_cost[layer] = heat_lvl_cost_base_rate[layer]
		heat_lvl_next_cost[layer] = heat_lvl_cost_base_rate[layer] * heat_lvl_multi_1
	if heat_lvl_cost[layer] == 1:
		soul_gen_rate[layer] = soul_gen_base_rate[layer] * heat_lvl_multi_1
		heat_lvl_cost[layer] = heat_lvl_cost_base_rate[layer] * heat_lvl_multi_1
		heat_lvl_next_cost[layer] = heat_lvl_cost_base_rate[layer] * heat_lvl_multi_2
	if heat_lvl_cost[layer] == 2:
		soul_gen_rate[layer] = soul_gen_base_rate[layer] * heat_lvl_multi_2
		heat_lvl_cost[layer] = heat_lvl_cost_base_rate[layer] * heat_lvl_multi_2
		heat_lvl_next_cost[layer] = heat_lvl_cost_base_rate[layer] * heat_lvl_multi_3
	if heat_lvl_cost[layer] == 3:
		soul_gen_rate[layer] = soul_gen_base_rate[layer] * heat_lvl_multi_3
		heat_lvl_cost[layer] = heat_lvl_cost_base_rate[layer] * heat_lvl_multi_3
		heat_lvl_next_cost[layer] = heat_lvl_cost_base_rate[layer] * heat_lvl_multi_4
	if heat_lvl_cost[layer] == 4:
		soul_gen_rate[layer] = soul_gen_base_rate[layer] * heat_lvl_multi_4
		heat_lvl_cost[layer] = heat_lvl_cost_base_rate[layer] * heat_lvl_multi_4
		heat_lvl_next_cost[layer] = heat_lvl_cost_base_rate[layer] * heat_lvl_multi_5
	if heat_lvl_cost[layer] >= 5:
		soul_gen_rate[layer] = soul_gen_base_rate[layer] * heat_lvl_multi_5
		heat_lvl_cost[layer] = heat_lvl_cost_base_rate[layer] * heat_lvl_multi_5
		heat_lvl_next_cost[layer] = 0
		heat_lvl[layer] = 5
	
	emit_layer_state(layer)
		
func _on_lust_heat_decay_timer_timeout() -> void:
	heat_lvl_decay("lust")

func heat_lvl_decay(layer):
	heat_lvl[layer] -= 1

	if heat_lvl[layer] == 0:
		soul_gen_rate[layer] = soul_gen_base_rate[layer]
		heat_lvl_next_cost[layer] = heat_lvl_cost_base_rate[layer] * heat_lvl_multi_1
	if heat_lvl[layer] == 1:
		soul_gen_rate[layer] = soul_gen_base_rate[layer] * heat_lvl_multi_1
		heat_lvl_next_cost[layer] = heat_lvl_cost_base_rate[layer] * heat_lvl_multi_2
	if heat_lvl[layer] == 2:
		soul_gen_rate[layer] = soul_gen_base_rate[layer] * heat_lvl_multi_2
		heat_lvl_next_cost[layer] = heat_lvl_cost_base_rate[layer] * heat_lvl_multi_3
	if heat_lvl[layer] == 3:
		soul_gen_rate[layer] = soul_gen_base_rate[layer] * heat_lvl_multi_3
		heat_lvl_next_cost[layer] = heat_lvl_cost_base_rate[layer] * heat_lvl_multi_4
	if heat_lvl[layer] == 4:
		soul_gen_rate[layer] = soul_gen_base_rate[layer] * heat_lvl_multi_4
		heat_lvl_next_cost[layer] = heat_lvl_cost_base_rate[layer] * heat_lvl_multi_5
	if heat_lvl[layer] >= 5:
		soul_gen_rate[layer] = soul_gen_base_rate[layer] * heat_lvl_multi_5
		heat_lvl_next_cost[layer] = 0
		heat_lvl[layer] = 5
	
	emit_layer_state(layer)

func people_die_message():
	pass
	
#random events
func random_event():
	pass

func add_first_fire():
	fire += 1

#convert souls to fire button pressed
func _on_lust_fire_pressed() -> void:
	convert_souls_to_fire(Layer.lust)

func hide_all_layers():
	pass

#init
func _ready() -> void:
	hide_all_layers()
	add_first_fire()
	
func _draw() -> void:
	pass
