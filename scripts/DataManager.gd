extends Node

#signals
signal fire_changed(new_amount)
signal souls_changed(new_amount)

#global ints
var fire: int = 0:
	set(value):
		fire = value
		fire_changed.emit(value)

var global_souls_total = 0:
	set(value):
		global_souls_total = value
		souls_changed.emit(value)

@export var lust_unlock_cost: int = 1
@export var gluttony_unlock_cost: int = 1000
@export var greed_unlock_cost: int = 15000
@export var sloth_unlock_cost: int = 60000
@export var wrath_unlock_cost: int = 500000
@export var envy_unlock_cost: int = 3000000
@export var pride_unlock_cost: int = 50000000

const HEAT_MULTIPLIERS = [1.2, 1.4, 2.0, 2.6, 3.2, 5.0]

var ticker_tweens: Dictionary = {}

var layers: Array = []

#tickers
@onready var lust_ticker = $"../LustLayer/LustUIToggle/LustSoulsTicker"
@onready var gluttony_ticker = $"../GluttonyLayer/GluttonyUIToggle/GluttonySoulsTicker"
@onready var greed_ticker = $"../GreedLayer/GreedUIToggle/GreedSoulsTicker"
@onready var sloth_ticker = $"../SlothLayer/SlothUIToggle/SlothSoulsTicker"
@onready var wrath_ticker = $"../WrathLayer/WrathUIToggle/WrathSoulsTicker"
@onready var envy_ticker = $"../EnvyLayer/EnvyUIToggle/EnvySoulsTicker"
@onready var pride_ticker = $"../PrideLayer/PrideUIToggle/PrideSoulsTicker"

func _ready() -> void:
	
	var lust = HellLayer.new()
	lust.layer_name = "lust"
	lust.heat_lvl_cost = 100
	lust.heat_lvl_cost_base_rate = 100
	lust.heat_lvl_next_cost = 100 * HEAT_MULTIPLIERS[0]
	lust.soul_gen_rate = 10
	lust.soul_gen_base_rate = 10
	lust.max_souls = 1000
	lust.decay_timer = $"../LustLayer/LustUIToggle/LustHeatDecayTimer"
	lust.progress_bar = $"../LustLayer/LustUIToggle/LustSoulsAmount"
	lust.temp_cost_text = $"../LustLayer/LustUIToggle/LustTempCost"
	lust.souls_per_sec_text = $"../LustLayer/LustUIToggle/LustSoulsPerSec"
	lust.tick_rate = 2.0
	layers.append(lust)
	
	var gluttony = HellLayer.new()
	gluttony.layer_name = "gluttony"
	gluttony.heat_lvl_cost = 300
	gluttony.heat_lvl_cost_base_rate = 300
	gluttony.heat_lvl_next_cost = 300 * HEAT_MULTIPLIERS[0]
	gluttony.soul_gen_rate = 60
	gluttony.soul_gen_base_rate = 60
	gluttony.max_souls = 5000
	gluttony.decay_timer = $"../GluttonyLayer/GluttonyUIToggle/GluttonyHeatDecayTimer"
	gluttony.progress_bar = $"../GluttonyLayer/GluttonyUIToggle/GluttonySoulsAmount"
	gluttony.temp_cost_text = $"../GluttonyLayer/GluttonyUIToggle/GluttonyTempCost"
	gluttony.souls_per_sec_text = $"../GluttonyLayer/GluttonyUIToggle/GluttonySoulsPerSec"
	gluttony.tick_rate = 2.0
	layers.append(gluttony)
	
	var greed = HellLayer.new()
	greed.layer_name = "greed"
	greed.heat_lvl_cost = 600
	greed.heat_lvl_cost_base_rate = 600
	greed.heat_lvl_next_cost = 600 * HEAT_MULTIPLIERS[0]
	greed.soul_gen_rate = 100
	greed.soul_gen_base_rate = 100
	greed.max_souls = 15000
	greed.decay_timer = $"../GreedLayer/GreedUIToggle/GreedHeatDecayTimer"
	greed.progress_bar = $"../GreedLayer/GreedUIToggle/GreedSoulsAmount"
	greed.temp_cost_text = $"../GreedLayer/GreedUIToggle/GreedTempCost"
	greed.souls_per_sec_text = $"../GreedLayer/GreedUIToggle/GreedSoulsPerSec"
	greed.tick_rate = 2.0
	layers.append(greed)
	
	var sloth = HellLayer.new()
	sloth.layer_name = "sloth"
	sloth.heat_lvl_cost = 1200
	sloth.heat_lvl_cost_base_rate = 1200
	sloth.heat_lvl_next_cost = 1200 * HEAT_MULTIPLIERS[0]
	sloth.soul_gen_rate = 200
	sloth.soul_gen_base_rate = 200
	sloth.max_souls = 30000
	sloth.decay_timer = $"../SlothLayer/SlothUIToggle/SlothHeatDecayTimer"
	sloth.progress_bar = $"../SlothLayer/SlothUIToggle/SlothSoulsAmount"
	sloth.temp_cost_text = $"../SlothLayer/SlothUIToggle/SlothTempCost"
	sloth.souls_per_sec_text = $"../SlothLayer/SlothUIToggle/SlothSoulsPerSec"
	sloth.tick_rate = 2.0
	layers.append(sloth)
	
	var wrath = HellLayer.new()
	wrath.layer_name = "wrath"
	wrath.heat_lvl_cost = 3000
	wrath.heat_lvl_cost_base_rate = 3000
	wrath.heat_lvl_next_cost = 3000 * HEAT_MULTIPLIERS[0]
	wrath.soul_gen_rate = 600
	wrath.soul_gen_base_rate = 600
	wrath.max_souls = 100000
	wrath.decay_timer = $"../WrathLayer/WrathUIToggle/WrathHeatDecayTimer"
	wrath.progress_bar = $"../WrathLayer/WrathUIToggle/WrathSoulsAmount"
	wrath.temp_cost_text = $"../WrathLayer/WrathUIToggle/WrathTempCost"
	wrath.souls_per_sec_text = $"../WrathLayer/WrathUIToggle/WrathSoulsPerSec"
	wrath.tick_rate = 2.0
	layers.append(wrath)
	
	var envy = HellLayer.new()
	envy.layer_name = "envy"
	envy.heat_lvl_cost = 10000
	envy.heat_lvl_cost_base_rate = 10000
	envy.heat_lvl_next_cost = 10000 * HEAT_MULTIPLIERS[0]
	envy.soul_gen_rate = 1200
	envy.soul_gen_base_rate = 1200
	envy.max_souls = 1000000
	envy.decay_timer = $"../EnvyLayer/EnvyUIToggle/EnvyHeatDecayTimer"
	envy.progress_bar = $"../EnvyLayer/EnvyUIToggle/EnvySoulsAmount"
	envy.temp_cost_text = $"../EnvyLayer/EnvyUIToggle/EnvyTempCost"
	envy.souls_per_sec_text = $"../EnvyLayer/EnvyUIToggle/EnvySoulsPerSec"
	envy.tick_rate = 2.0
	layers.append(envy)
	
	var pride = HellLayer.new()
	pride.layer_name = "pride"
	pride.heat_lvl_cost = 50000
	pride.heat_lvl_cost_base_rate = 50000
	pride.heat_lvl_next_cost = 50000 * HEAT_MULTIPLIERS[0]
	pride.soul_gen_rate = 3000
	pride.soul_gen_base_rate = 3000
	pride.max_souls = 1000000
	pride.decay_timer = $"../PrideLayer/PrideUIToggle/PrideHeatDecayTimer"
	pride.progress_bar = $"../PrideLayer/PrideUIToggle/PrideSoulsAmount"
	pride.temp_cost_text = $"../PrideLayer/PrideUIToggle/PrideTempCost"
	pride.souls_per_sec_text = $"../PrideLayer/PrideUIToggle/PrideSoulsPerSec"
	pride.tick_rate = 2.0
	layers.append(pride)
	
	hide_all_layers()
	add_first_fire()
	ticker_animate(0, lust_ticker)
	ticker_animate(1, gluttony_ticker)
	ticker_animate(2, greed_ticker)
	ticker_animate(3, sloth_ticker)
	ticker_animate(4, wrath_ticker)
	ticker_animate(5, envy_ticker)
	ticker_animate(6, pride_ticker)
	
	
func sum_all_souls():
	global_souls_total = 0
	for layer in layers:
		global_souls_total += layer.souls

func ticker_animate(i, ticker):
	if ticker_tweens.has(i):
		ticker_tweens[i].kill()
	var tween = create_tween()
	tween.set_loops()
	tween.tween_property(ticker, "value", 100.0, layers[i].tick_rate)
	tween.tween_property(ticker, "value", 0.0, 0.0)
	ticker_tweens[i] = tween

#fills up layers w souls
func _on_souls_regen_timer_timeout() -> void:
	for i in layers.size():
		if layers[i].layer_unlocked == true:
			layers[i].souls += layers[i].soul_gen_rate
			layers[i].progress_bar.value = layers[i].souls
			if layers[i].souls >= layers[i].max_souls:
				layers[i].souls = layers[i].max_souls
	
	sum_all_souls()
	
func convert_souls_to_fire(i: int):
	fire += layers[i].souls
	layers[i].souls = 0

#HEAT LVL BUTTONS

#LUST
func _on_lust_temp_all_pressed() -> void:
	heat_lvl_up(0)
	lust_UI_refresh()
	
func _on_lust_heat_decay_timer_timeout() -> void:
	heat_lvl_decay(0)
	lust_UI_refresh()

func lust_UI_refresh():
	var lust_heat_cost_UI = $"../LustLayer/LustUIToggle/LustTempCost"
	$"../LustLayer/LustUIToggle/LustSoulsPerSec".text = str(layers[0].soul_gen_rate, "/sec")
	if layers[0].heat_lvl == 0:
		$"../LustLayer/LustUIToggle/Lust_Temp_0".show()
		$"../LustLayer/LustUIToggle/Lust_Temp_1".hide()
		$"../LustLayer/LustUIToggle/Lust_Temp_2".hide()
		$"../LustLayer/LustUIToggle/Lust_Temp_3".hide()
		$"../LustLayer/LustUIToggle/Lust_Temp_4".hide()
		$"../LustLayer/LustUIToggle/Lust_Temp_5".hide()
		lust_ticker.tint_progress = Color("#0f3363")
		lust_heat_cost_UI.text = str(layers[0].heat_lvl_next_cost)
		layers[0].tick_rate = 2.0
		ticker_animate(0, lust_ticker)
	if layers[0].heat_lvl == 1:
		$"../LustLayer/LustUIToggle/Lust_Temp_0".hide()
		$"../LustLayer/LustUIToggle/Lust_Temp_1".show()
		$"../LustLayer/LustUIToggle/Lust_Temp_2".hide()
		$"../LustLayer/LustUIToggle/Lust_Temp_3".hide()
		$"../LustLayer/LustUIToggle/Lust_Temp_4".hide()
		$"../LustLayer/LustUIToggle/Lust_Temp_5".hide()
		lust_ticker.tint_progress = Color("#3173c9")
		lust_heat_cost_UI.text = str(layers[0].heat_lvl_next_cost)
		layers[0].tick_rate = 1.0
		ticker_animate(0, lust_ticker)
	if layers[0].heat_lvl == 2:
		$"../LustLayer/LustUIToggle/Lust_Temp_0".hide()
		$"../LustLayer/LustUIToggle/Lust_Temp_1".hide()
		$"../LustLayer/LustUIToggle/Lust_Temp_2".show()
		$"../LustLayer/LustUIToggle/Lust_Temp_3".hide()
		$"../LustLayer/LustUIToggle/Lust_Temp_4".hide()
		$"../LustLayer/LustUIToggle/Lust_Temp_5".hide()
		lust_ticker.tint_progress = Color("#56a683")
		lust_heat_cost_UI.text = str(layers[0].heat_lvl_next_cost)
		layers[0].tick_rate = 0.8
		ticker_animate(0, lust_ticker)
	if layers[0].heat_lvl == 3:
		$"../LustLayer/LustUIToggle/Lust_Temp_0".hide()
		$"../LustLayer/LustUIToggle/Lust_Temp_1".hide()
		$"../LustLayer/LustUIToggle/Lust_Temp_2".hide()
		$"../LustLayer/LustUIToggle/Lust_Temp_3".show()
		$"../LustLayer/LustUIToggle/Lust_Temp_4".hide()
		$"../LustLayer/LustUIToggle/Lust_Temp_5".hide()
		lust_ticker.tint_progress = Color("#e3da51")
		lust_heat_cost_UI.text = str(layers[0].heat_lvl_next_cost)
		layers[0].tick_rate = 0.6
		ticker_animate(0, lust_ticker)
	if layers[0].heat_lvl == 4:
		$"../LustLayer/LustUIToggle/Lust_Temp_0".hide()
		$"../LustLayer/LustUIToggle/Lust_Temp_1".hide()
		$"../LustLayer/LustUIToggle/Lust_Temp_2".hide()
		$"../LustLayer/LustUIToggle/Lust_Temp_3".hide()
		$"../LustLayer/LustUIToggle/Lust_Temp_4".show()
		$"../LustLayer/LustUIToggle/Lust_Temp_5".hide()
		lust_ticker.tint_progress = Color("#efa03b")
		lust_heat_cost_UI.text = str(layers[0].heat_lvl_next_cost)
		layers[0].tick_rate = 0.4
		ticker_animate(0, lust_ticker)
	if layers[0].heat_lvl >= 5:
		$"../LustLayer/LustUIToggle/Lust_Temp_0".hide()
		$"../LustLayer/LustUIToggle/Lust_Temp_1".hide()
		$"../LustLayer/LustUIToggle/Lust_Temp_2".hide()
		$"../LustLayer/LustUIToggle/Lust_Temp_3".hide()
		$"../LustLayer/LustUIToggle/Lust_Temp_4".hide()
		$"../LustLayer/LustUIToggle/Lust_Temp_5".show()
		lust_ticker.tint_progress = Color("#e65238")
		layers[0].tick_rate = 0.1
		ticker_animate(0, lust_ticker)
		lust_heat_cost_UI.text = "MAX"
		
#GLUTTONY
func _on_gluttony_temp_pressed() -> void:
	heat_lvl_up(1)
	gluttony_UI_refresh()
	
func _on_gluttony_heat_decay_timer_timeout() -> void:
	heat_lvl_decay(1)
	gluttony_UI_refresh()

func gluttony_UI_refresh():
	var gluttony_heat_cost_UI = $"../GluttonyLayer/GluttonyUIToggle/GluttonyTempCost"
	$"../GluttonyLayer/GluttonyUIToggle/GluttonySoulsPerSec".text = str(layers[1].soul_gen_rate, "/sec")
	if layers[1].heat_lvl == 0:
		$"../GluttonyLayer/GluttonyUIToggle/Gluttony_Temp_0".show()
		$"../GluttonyLayer/GluttonyUIToggle/Gluttony_Temp_1".hide()
		$"../GluttonyLayer/GluttonyUIToggle/Gluttony_Temp_2".hide()
		$"../GluttonyLayer/GluttonyUIToggle/Gluttony_Temp_3".hide()
		$"../GluttonyLayer/GluttonyUIToggle/Gluttony_Temp_4".hide()
		$"../GluttonyLayer/GluttonyUIToggle/Gluttony_Temp_5".hide()
		gluttony_ticker.tint_progress = Color("#0f3363")
		gluttony_heat_cost_UI.text = str(layers[1].heat_lvl_next_cost)
		layers[1].tick_rate = 2.0
		ticker_animate(1, gluttony_ticker)
	if layers[1].heat_lvl == 1:
		$"../GluttonyLayer/GluttonyUIToggle/Gluttony_Temp_0".hide()
		$"../GluttonyLayer/GluttonyUIToggle/Gluttony_Temp_1".show()
		$"../GluttonyLayer/GluttonyUIToggle/Gluttony_Temp_2".hide()
		$"../GluttonyLayer/GluttonyUIToggle/Gluttony_Temp_3".hide()
		$"../GluttonyLayer/GluttonyUIToggle/Gluttony_Temp_4".hide()
		$"../GluttonyLayer/GluttonyUIToggle/Gluttony_Temp_5".hide()
		gluttony_ticker.tint_progress = Color("#3173c9")
		gluttony_heat_cost_UI.text = str(layers[1].heat_lvl_next_cost)
		layers[1].tick_rate = 1.0
		ticker_animate(1, gluttony_ticker)
	if layers[1].heat_lvl == 2:
		$"../GluttonyLayer/GluttonyUIToggle/Gluttony_Temp_0".hide()
		$"../GluttonyLayer/GluttonyUIToggle/Gluttony_Temp_1".hide()
		$"../GluttonyLayer/GluttonyUIToggle/Gluttony_Temp_2".show()
		$"../GluttonyLayer/GluttonyUIToggle/Gluttony_Temp_3".hide()
		$"../GluttonyLayer/GluttonyUIToggle/Gluttony_Temp_4".hide()
		$"../GluttonyLayer/GluttonyUIToggle/Gluttony_Temp_5".hide()
		gluttony_ticker.tint_progress = Color("#56a683")
		gluttony_heat_cost_UI.text = str(layers[1].heat_lvl_next_cost)
		layers[1].tick_rate = 0.8
		ticker_animate(1, gluttony_ticker)
	if layers[1].heat_lvl == 3:
		$"../GluttonyLayer/GluttonyUIToggle/Gluttony_Temp_0".hide()
		$"../GluttonyLayer/GluttonyUIToggle/Gluttony_Temp_1".hide()
		$"../GluttonyLayer/GluttonyUIToggle/Gluttony_Temp_2".hide()
		$"../GluttonyLayer/GluttonyUIToggle/Gluttony_Temp_3".show()
		$"../GluttonyLayer/GluttonyUIToggle/Gluttony_Temp_4".hide()
		$"../GluttonyLayer/GluttonyUIToggle/Gluttony_Temp_5".hide()
		gluttony_ticker.tint_progress = Color("#e3da51")
		gluttony_heat_cost_UI.text = str(layers[1].heat_lvl_next_cost)
		layers[1].tick_rate = 0.6
		ticker_animate(1, gluttony_ticker)
	if layers[1].heat_lvl == 4:
		$"../GluttonyLayer/GluttonyUIToggle/Gluttony_Temp_0".hide()
		$"../GluttonyLayer/GluttonyUIToggle/Gluttony_Temp_1".hide()
		$"../GluttonyLayer/GluttonyUIToggle/Gluttony_Temp_2".hide()
		$"../GluttonyLayer/GluttonyUIToggle/Gluttony_Temp_3".hide()
		$"../GluttonyLayer/GluttonyUIToggle/Gluttony_Temp_4".show()
		$"../GluttonyLayer/GluttonyUIToggle/Gluttony_Temp_5".hide()
		gluttony_ticker.tint_progress = Color("#efa03b")
		gluttony_heat_cost_UI.text = str(layers[1].heat_lvl_next_cost)
		layers[1].tick_rate = 0.4
		ticker_animate(1, gluttony_ticker)
	if layers[1].heat_lvl >= 5:
		$"../GluttonyLayer/GluttonyUIToggle/Gluttony_Temp_0".hide()
		$"../GluttonyLayer/GluttonyUIToggle/Gluttony_Temp_1".hide()
		$"../GluttonyLayer/GluttonyUIToggle/Gluttony_Temp_2".hide()
		$"../GluttonyLayer/GluttonyUIToggle/Gluttony_Temp_3".hide()
		$"../GluttonyLayer/GluttonyUIToggle/Gluttony_Temp_4".hide()
		$"../GluttonyLayer/GluttonyUIToggle/Gluttony_Temp_5".show()
		gluttony_ticker.tint_progress = Color("#e65238")
		layers[1].tick_rate = 0.1
		ticker_animate(1, gluttony_ticker)
		gluttony_heat_cost_UI.text = "MAX"

#GREED
func _on_greed_temp_pressed() -> void:
	heat_lvl_up(2)
	greed_UI_refresh()

func _on_greed_heat_decay_timer_timeout() -> void:
	heat_lvl_decay(2)
	greed_UI_refresh()

func greed_UI_refresh():
	var greed_heat_cost_UI = $"../GreedLayer/GreedUIToggle/GreedTempCost"
	$"../GreedLayer/GreedUIToggle/GreedSoulsPerSec".text = str(layers[2].soul_gen_rate, "/sec")
	if layers[2].heat_lvl == 0:
		$"../GreedLayer/GreedUIToggle/Greed_Temp_0".show()
		$"../GreedLayer/GreedUIToggle/Greed_Temp_1".hide()
		$"../GreedLayer/GreedUIToggle/Greed_Temp_2".hide()
		$"../GreedLayer/GreedUIToggle/Greed_Temp_3".hide()
		$"../GreedLayer/GreedUIToggle/Greed_Temp_4".hide()
		$"../GreedLayer/GreedUIToggle/Greed_Temp_5".hide()
		greed_ticker.tint_progress = Color("#0f3363")
		greed_heat_cost_UI.text = str(layers[2].heat_lvl_next_cost)
		layers[2].tick_rate = 2.0
		ticker_animate(2, greed_ticker)
	if layers[2].heat_lvl == 1:
		$"../GreedLayer/GreedUIToggle/Greed_Temp_0".hide()
		$"../GreedLayer/GreedUIToggle/Greed_Temp_1".show()
		$"../GreedLayer/GreedUIToggle/Greed_Temp_2".hide()
		$"../GreedLayer/GreedUIToggle/Greed_Temp_3".hide()
		$"../GreedLayer/GreedUIToggle/Greed_Temp_4".hide()
		$"../GreedLayer/GreedUIToggle/Greed_Temp_5".hide()
		greed_ticker.tint_progress = Color("#3173c9")
		greed_heat_cost_UI.text = str(layers[2].heat_lvl_next_cost)
		layers[2].tick_rate = 1.0
		ticker_animate(2, greed_ticker)
	if layers[2].heat_lvl == 2:
		$"../GreedLayer/GreedUIToggle/Greed_Temp_0".hide()
		$"../GreedLayer/GreedUIToggle/Greed_Temp_1".hide()
		$"../GreedLayer/GreedUIToggle/Greed_Temp_2".show()
		$"../GreedLayer/GreedUIToggle/Greed_Temp_3".hide()
		$"../GreedLayer/GreedUIToggle/Greed_Temp_4".hide()
		$"../GreedLayer/GreedUIToggle/Greed_Temp_5".hide()
		greed_ticker.tint_progress = Color("#56a683")
		greed_heat_cost_UI.text = str(layers[2].heat_lvl_next_cost)
		layers[2].tick_rate = 0.8
		ticker_animate(2, greed_ticker)
	if layers[2].heat_lvl == 3:
		$"../GreedLayer/GreedUIToggle/Greed_Temp_0".hide()
		$"../GreedLayer/GreedUIToggle/Greed_Temp_1".hide()
		$"../GreedLayer/GreedUIToggle/Greed_Temp_2".hide()
		$"../GreedLayer/GreedUIToggle/Greed_Temp_3".show()
		$"../GreedLayer/GreedUIToggle/Greed_Temp_4".hide()
		$"../GreedLayer/GreedUIToggle/Greed_Temp_5".hide()
		greed_ticker.tint_progress = Color("#e3da51")
		greed_heat_cost_UI.text = str(layers[2].heat_lvl_next_cost)
		layers[2].tick_rate = 0.6
		ticker_animate(2, greed_ticker)
	if layers[2].heat_lvl == 4:
		$"../GreedLayer/GreedUIToggle/Greed_Temp_0".hide()
		$"../GreedLayer/GreedUIToggle/Greed_Temp_1".hide()
		$"../GreedLayer/GreedUIToggle/Greed_Temp_2".hide()
		$"../GreedLayer/GreedUIToggle/Greed_Temp_3".hide()
		$"../GreedLayer/GreedUIToggle/Greed_Temp_4".show()
		$"../GreedLayer/GreedUIToggle/Greed_Temp_5".hide()
		greed_ticker.tint_progress = Color("#efa03b")
		greed_heat_cost_UI.text = str(layers[2].heat_lvl_next_cost)
		layers[2].tick_rate = 0.4
		ticker_animate(2, greed_ticker)
	if layers[2].heat_lvl >= 5:
		$"../GreedLayer/GreedUIToggle/Greed_Temp_0".hide()
		$"../GreedLayer/GreedUIToggle/Greed_Temp_1".hide()
		$"../GreedLayer/GreedUIToggle/Greed_Temp_2".hide()
		$"../GreedLayer/GreedUIToggle/Greed_Temp_3".hide()
		$"../GreedLayer/GreedUIToggle/Greed_Temp_4".hide()
		$"../GreedLayer/GreedUIToggle/Greed_Temp_5".show()
		greed_ticker.tint_progress = Color("#e65238")
		layers[2].tick_rate = 0.1
		ticker_animate(2, greed_ticker)
		greed_heat_cost_UI.text = "MAX"

#SLOTH
func _on_sloth_temp_pressed() -> void:
	heat_lvl_up(3)
	sloth_UI_refresh()

func _on_sloth_heat_decay_timer_timeout() -> void:
	heat_lvl_decay(3)
	sloth_UI_refresh()

func sloth_UI_refresh():
	var sloth_heat_cost_UI = $"../SlothLayer/SlothUIToggle/SlothTempCost"
	$"../SlothLayer/SlothUIToggle/SlothSoulsPerSec".text = str(layers[3].soul_gen_rate, "/sec")
	if layers[3].heat_lvl == 0:
		$"../SlothLayer/SlothUIToggle/Sloth_Temp_0".show()
		$"../SlothLayer/SlothUIToggle/Sloth_Temp_1".hide()
		$"../SlothLayer/SlothUIToggle/Sloth_Temp_2".hide()
		$"../SlothLayer/SlothUIToggle/Sloth_Temp_3".hide()
		$"../SlothLayer/SlothUIToggle/Sloth_Temp_4".hide()
		$"../SlothLayer/SlothUIToggle/Sloth_Temp_5".hide()
		sloth_ticker.tint_progress = Color("#0f3363")
		sloth_heat_cost_UI.text = str(layers[3].heat_lvl_next_cost)
		layers[3].tick_rate = 2.0
		ticker_animate(3, sloth_ticker)
	if layers[3].heat_lvl == 1:
		$"../SlothLayer/SlothUIToggle/Sloth_Temp_0".hide()
		$"../SlothLayer/SlothUIToggle/Sloth_Temp_1".show()
		$"../SlothLayer/SlothUIToggle/Sloth_Temp_2".hide()
		$"../SlothLayer/SlothUIToggle/Sloth_Temp_3".hide()
		$"../SlothLayer/SlothUIToggle/Sloth_Temp_4".hide()
		$"../SlothLayer/SlothUIToggle/Sloth_Temp_5".hide()
		sloth_ticker.tint_progress = Color("#3173c9")
		sloth_heat_cost_UI.text = str(layers[3].heat_lvl_next_cost)
		layers[3].tick_rate = 1.0
		ticker_animate(3, sloth_ticker)
	if layers[3].heat_lvl == 2:
		$"../SlothLayer/SlothUIToggle/Sloth_Temp_0".hide()
		$"../SlothLayer/SlothUIToggle/Sloth_Temp_1".hide()
		$"../SlothLayer/SlothUIToggle/Sloth_Temp_2".show()
		$"../SlothLayer/SlothUIToggle/Sloth_Temp_3".hide()
		$"../SlothLayer/SlothUIToggle/Sloth_Temp_4".hide()
		$"../SlothLayer/SlothUIToggle/Sloth_Temp_5".hide()
		sloth_ticker.tint_progress = Color("#56a683")
		sloth_heat_cost_UI.text = str(layers[3].heat_lvl_next_cost)
		layers[3].tick_rate = 0.8
		ticker_animate(3, sloth_ticker)
	if layers[3].heat_lvl == 3:
		$"../SlothLayer/SlothUIToggle/Sloth_Temp_0".hide()
		$"../SlothLayer/SlothUIToggle/Sloth_Temp_1".hide()
		$"../SlothLayer/SlothUIToggle/Sloth_Temp_2".hide()
		$"../SlothLayer/SlothUIToggle/Sloth_Temp_3".show()
		$"../SlothLayer/SlothUIToggle/Sloth_Temp_4".hide()
		$"../SlothLayer/SlothUIToggle/Sloth_Temp_5".hide()
		sloth_ticker.tint_progress = Color("#e3da51")
		sloth_heat_cost_UI.text = str(layers[3].heat_lvl_next_cost)
		layers[3].tick_rate = 0.6
		ticker_animate(3, sloth_ticker)
	if layers[3].heat_lvl == 4:
		$"../SlothLayer/SlothUIToggle/Sloth_Temp_0".hide()
		$"../SlothLayer/SlothUIToggle/Sloth_Temp_1".hide()
		$"../SlothLayer/SlothUIToggle/Sloth_Temp_2".hide()
		$"../SlothLayer/SlothUIToggle/Sloth_Temp_3".hide()
		$"../SlothLayer/SlothUIToggle/Sloth_Temp_4".show()
		$"../SlothLayer/SlothUIToggle/Sloth_Temp_5".hide()
		sloth_ticker.tint_progress = Color("#efa03b")
		sloth_heat_cost_UI.text = str(layers[3].heat_lvl_next_cost)
		layers[3].tick_rate = 0.4
		ticker_animate(3, sloth_ticker)
	if layers[3].heat_lvl >= 5:
		$"../SlothLayer/SlothUIToggle/Sloth_Temp_0".hide()
		$"../SlothLayer/SlothUIToggle/Sloth_Temp_1".hide()
		$"../SlothLayer/SlothUIToggle/Sloth_Temp_2".hide()
		$"../SlothLayer/SlothUIToggle/Sloth_Temp_3".hide()
		$"../SlothLayer/SlothUIToggle/Sloth_Temp_4".hide()
		$"../SlothLayer/SlothUIToggle/Sloth_Temp_5".show()
		sloth_ticker.tint_progress = Color("#e65238")
		layers[3].tick_rate = 0.1
		ticker_animate(3, sloth_ticker)
		sloth_heat_cost_UI.text = "MAX"

#WRATH
func _on_wrath_temp_pressed() -> void:
	heat_lvl_up(4)
	wrath_UI_refresh()

func _on_wrath_heat_decay_timer_timeout() -> void:
	heat_lvl_decay(4)
	wrath_UI_refresh()

func wrath_UI_refresh():
	var wrath_heat_cost_UI = $"../WrathLayer/WrathUIToggle/WrathTempCost"
	$"../WrathLayer/WrathUIToggle/WrathSoulsPerSec".text = str(layers[4].soul_gen_rate, "/sec")
	if layers[4].heat_lvl == 0:
		$"../WrathLayer/WrathUIToggle/Wrath_Temp_0".show()
		$"../WrathLayer/WrathUIToggle/Wrath_Temp_1".hide()
		$"../WrathLayer/WrathUIToggle/Wrath_Temp_2".hide()
		$"../WrathLayer/WrathUIToggle/Wrath_Temp_3".hide()
		$"../WrathLayer/WrathUIToggle/Wrath_Temp_4".hide()
		$"../WrathLayer/WrathUIToggle/Wrath_Temp_5".hide()
		wrath_ticker.tint_progress = Color("#0f3363")
		wrath_heat_cost_UI.text = str(layers[4].heat_lvl_next_cost)
		layers[4].tick_rate = 2.0
		ticker_animate(4, wrath_ticker)
	if layers[4].heat_lvl == 1:
		$"../WrathLayer/WrathUIToggle/Wrath_Temp_0".hide()
		$"../WrathLayer/WrathUIToggle/Wrath_Temp_1".show()
		$"../WrathLayer/WrathUIToggle/Wrath_Temp_2".hide()
		$"../WrathLayer/WrathUIToggle/Wrath_Temp_3".hide()
		$"../WrathLayer/WrathUIToggle/Wrath_Temp_4".hide()
		$"../WrathLayer/WrathUIToggle/Wrath_Temp_5".hide()
		wrath_ticker.tint_progress = Color("#3173c9")
		wrath_heat_cost_UI.text = str(layers[4].heat_lvl_next_cost)
		layers[4].tick_rate = 1.0
		ticker_animate(4, wrath_ticker)
	if layers[4].heat_lvl == 2:
		$"../WrathLayer/WrathUIToggle/Wrath_Temp_0".hide()
		$"../WrathLayer/WrathUIToggle/Wrath_Temp_1".hide()
		$"../WrathLayer/WrathUIToggle/Wrath_Temp_2".show()
		$"../WrathLayer/WrathUIToggle/Wrath_Temp_3".hide()
		$"../WrathLayer/WrathUIToggle/Wrath_Temp_4".hide()
		$"../WrathLayer/WrathUIToggle/Wrath_Temp_5".hide()
		wrath_ticker.tint_progress = Color("#56a683")
		wrath_heat_cost_UI.text = str(layers[4].heat_lvl_next_cost)
		layers[4].tick_rate = 0.8
		ticker_animate(4, wrath_ticker)
	if layers[4].heat_lvl == 3:
		$"../WrathLayer/WrathUIToggle/Wrath_Temp_0".hide()
		$"../WrathLayer/WrathUIToggle/Wrath_Temp_1".hide()
		$"../WrathLayer/WrathUIToggle/Wrath_Temp_2".hide()
		$"../WrathLayer/WrathUIToggle/Wrath_Temp_3".show()
		$"../WrathLayer/WrathUIToggle/Wrath_Temp_4".hide()
		$"../WrathLayer/WrathUIToggle/Wrath_Temp_5".hide()
		wrath_ticker.tint_progress = Color("#e3da51")
		wrath_heat_cost_UI.text = str(layers[4].heat_lvl_next_cost)
		layers[4].tick_rate = 0.6
		ticker_animate(4, wrath_ticker)
	if layers[4].heat_lvl == 4:
		$"../WrathLayer/WrathUIToggle/Wrath_Temp_0".hide()
		$"../WrathLayer/WrathUIToggle/Wrath_Temp_1".hide()
		$"../WrathLayer/WrathUIToggle/Wrath_Temp_2".hide()
		$"../WrathLayer/WrathUIToggle/Wrath_Temp_3".hide()
		$"../WrathLayer/WrathUIToggle/Wrath_Temp_4".show()
		$"../WrathLayer/WrathUIToggle/Wrath_Temp_5".hide()
		wrath_ticker.tint_progress = Color("#efa03b")
		wrath_heat_cost_UI.text = str(layers[4].heat_lvl_next_cost)
		layers[4].tick_rate = 0.4
		ticker_animate(4, wrath_ticker)
	if layers[4].heat_lvl >= 5:
		$"../WrathLayer/WrathUIToggle/Wrath_Temp_0".hide()
		$"../WrathLayer/WrathUIToggle/Wrath_Temp_1".hide()
		$"../WrathLayer/WrathUIToggle/Wrath_Temp_2".hide()
		$"../WrathLayer/WrathUIToggle/Wrath_Temp_3".hide()
		$"../WrathLayer/WrathUIToggle/Wrath_Temp_4".hide()
		$"../WrathLayer/WrathUIToggle/Wrath_Temp_5".show()
		wrath_ticker.tint_progress = Color("#e65238")
		layers[4].tick_rate = 0.1
		ticker_animate(4, wrath_ticker)
		wrath_heat_cost_UI.text = "MAX"

#ENVY
func _on_envy_temp_pressed() -> void:
	heat_lvl_up(5)
	envy_UI_refresh()

func _on_envy_heat_decay_timer_timeout() -> void:
	heat_lvl_decay(5)
	envy_UI_refresh()

func envy_UI_refresh():
	var envy_heat_cost_UI = $"../EnvyLayer/EnvyUIToggle/EnvyTempCost"
	$"../EnvyLayer/EnvyUIToggle/EnvySoulsPerSec".text = str(layers[5].soul_gen_rate, "/sec")
	if layers[5].heat_lvl == 0:
		$"../EnvyLayer/EnvyUIToggle/Envy_Temp_0".show()
		$"../EnvyLayer/EnvyUIToggle/Envy_Temp_1".hide()
		$"../EnvyLayer/EnvyUIToggle/Envy_Temp_2".hide()
		$"../EnvyLayer/EnvyUIToggle/Envy_Temp_3".hide()
		$"../EnvyLayer/EnvyUIToggle/Envy_Temp_4".hide()
		$"../EnvyLayer/EnvyUIToggle/Envy_Temp_5".hide()
		envy_ticker.tint_progress = Color("#0f3363")
		envy_heat_cost_UI.text = str(layers[5].heat_lvl_next_cost)
		layers[5].tick_rate = 2.0
		ticker_animate(5, envy_ticker)
	if layers[5].heat_lvl == 1:
		$"../EnvyLayer/EnvyUIToggle/Envy_Temp_0".hide()
		$"../EnvyLayer/EnvyUIToggle/Envy_Temp_1".show()
		$"../EnvyLayer/EnvyUIToggle/Envy_Temp_2".hide()
		$"../EnvyLayer/EnvyUIToggle/Envy_Temp_3".hide()
		$"../EnvyLayer/EnvyUIToggle/Envy_Temp_4".hide()
		$"../EnvyLayer/EnvyUIToggle/Envy_Temp_5".hide()
		envy_ticker.tint_progress = Color("#3173c9")
		envy_heat_cost_UI.text = str(layers[5].heat_lvl_next_cost)
		layers[5].tick_rate = 1.0
		ticker_animate(5, envy_ticker)
	if layers[5].heat_lvl == 2:
		$"../EnvyLayer/EnvyUIToggle/Envy_Temp_0".hide()
		$"../EnvyLayer/EnvyUIToggle/Envy_Temp_1".hide()
		$"../EnvyLayer/EnvyUIToggle/Envy_Temp_2".show()
		$"../EnvyLayer/EnvyUIToggle/Envy_Temp_3".hide()
		$"../EnvyLayer/EnvyUIToggle/Envy_Temp_4".hide()
		$"../EnvyLayer/EnvyUIToggle/Envy_Temp_5".hide()
		envy_ticker.tint_progress = Color("#56a683")
		envy_heat_cost_UI.text = str(layers[5].heat_lvl_next_cost)
		layers[5].tick_rate = 0.8
		ticker_animate(5, envy_ticker)
	if layers[5].heat_lvl == 3:
		$"../EnvyLayer/EnvyUIToggle/Envy_Temp_0".hide()
		$"../EnvyLayer/EnvyUIToggle/Envy_Temp_1".hide()
		$"../EnvyLayer/EnvyUIToggle/Envy_Temp_2".hide()
		$"../EnvyLayer/EnvyUIToggle/Envy_Temp_3".show()
		$"../EnvyLayer/EnvyUIToggle/Envy_Temp_4".hide()
		$"../EnvyLayer/EnvyUIToggle/Envy_Temp_5".hide()
		envy_ticker.tint_progress = Color("#e3da51")
		envy_heat_cost_UI.text = str(layers[5].heat_lvl_next_cost)
		layers[5].tick_rate = 0.6
		ticker_animate(5, envy_ticker)
	if layers[5].heat_lvl == 4:
		$"../EnvyLayer/EnvyUIToggle/Envy_Temp_0".hide()
		$"../EnvyLayer/EnvyUIToggle/Envy_Temp_1".hide()
		$"../EnvyLayer/EnvyUIToggle/Envy_Temp_2".hide()
		$"../EnvyLayer/EnvyUIToggle/Envy_Temp_3".hide()
		$"../EnvyLayer/EnvyUIToggle/Envy_Temp_4".show()
		$"../EnvyLayer/EnvyUIToggle/Envy_Temp_5".hide()
		envy_ticker.tint_progress = Color("#efa03b")
		envy_heat_cost_UI.text = str(layers[5].heat_lvl_next_cost)
		layers[5].tick_rate = 0.4
		ticker_animate(5, envy_ticker)
	if layers[5].heat_lvl >= 5:
		$"../EnvyLayer/EnvyUIToggle/Envy_Temp_0".hide()
		$"../EnvyLayer/EnvyUIToggle/Envy_Temp_1".hide()
		$"../EnvyLayer/EnvyUIToggle/Envy_Temp_2".hide()
		$"../EnvyLayer/EnvyUIToggle/Envy_Temp_3".hide()
		$"../EnvyLayer/EnvyUIToggle/Envy_Temp_4".hide()
		$"../EnvyLayer/EnvyUIToggle/Envy_Temp_5".show()
		envy_ticker.tint_progress = Color("#e65238")
		layers[5].tick_rate = 0.1
		ticker_animate(5, envy_ticker)
		envy_heat_cost_UI.text = "MAX"
		
#ENVY
func _on_pride_temp_pressed() -> void:
	heat_lvl_up(6)
	pride_UI_refresh()

func _on_pride_heat_decay_timer_timeout() -> void:
	heat_lvl_decay(6)
	pride_UI_refresh()

func pride_UI_refresh():
	var pride_heat_cost_UI = $"../PrideLayer/PrideUIToggle/PrideTempCost"
	$"../PrideLayer/PrideUIToggle/PrideSoulsPerSec".text = str(layers[6].soul_gen_rate, "/sec")
	if layers[6].heat_lvl == 0:
		$"../PrideLayer/PrideUIToggle/Pride_Temp_0".show()
		$"../PrideLayer/PrideUIToggle/Pride_Temp_1".hide()
		$"../PrideLayer/PrideUIToggle/Pride_Temp_2".hide()
		$"../PrideLayer/PrideUIToggle/Pride_Temp_3".hide()
		$"../PrideLayer/PrideUIToggle/Pride_Temp_4".hide()
		$"../PrideLayer/PrideUIToggle/Pride_Temp_5".hide()
		pride_ticker.tint_progress = Color("#0f3363")
		pride_heat_cost_UI.text = str(layers[6].heat_lvl_next_cost)
		layers[6].tick_rate = 2.0
		ticker_animate(6, pride_ticker)
	if layers[6].heat_lvl == 1:
		$"../PrideLayer/PrideUIToggle/Pride_Temp_0".hide()
		$"../PrideLayer/PrideUIToggle/Pride_Temp_1".show()
		$"../PrideLayer/PrideUIToggle/Pride_Temp_2".hide()
		$"../PrideLayer/PrideUIToggle/Pride_Temp_3".hide()
		$"../PrideLayer/PrideUIToggle/Pride_Temp_4".hide()
		$"../PrideLayer/PrideUIToggle/Pride_Temp_5".hide()
		pride_ticker.tint_progress = Color("#3173c9")
		pride_heat_cost_UI.text = str(layers[6].heat_lvl_next_cost)
		layers[6].tick_rate = 1.0
		ticker_animate(6, pride_ticker)
	if layers[6].heat_lvl == 2:
		$"../PrideLayer/PrideUIToggle/Pride_Temp_0".hide()
		$"../PrideLayer/PrideUIToggle/Pride_Temp_1".hide()
		$"../PrideLayer/PrideUIToggle/Pride_Temp_2".show()
		$"../PrideLayer/PrideUIToggle/Pride_Temp_3".hide()
		$"../PrideLayer/PrideUIToggle/Pride_Temp_4".hide()
		$"../PrideLayer/PrideUIToggle/Pride_Temp_5".hide()
		pride_ticker.tint_progress = Color("#56a683")
		pride_heat_cost_UI.text = str(layers[6].heat_lvl_next_cost)
		layers[6].tick_rate = 0.8
		ticker_animate(6, pride_ticker)
	if layers[6].heat_lvl == 3:
		$"../PrideLayer/PrideUIToggle/Pride_Temp_0".hide()
		$"../PrideLayer/PrideUIToggle/Pride_Temp_1".hide()
		$"../PrideLayer/PrideUIToggle/Pride_Temp_2".hide()
		$"../PrideLayer/PrideUIToggle/Pride_Temp_3".show()
		$"../PrideLayer/PrideUIToggle/Pride_Temp_4".hide()
		$"../PrideLayer/PrideUIToggle/Pride_Temp_5".hide()
		pride_ticker.tint_progress = Color("#e3da51")
		pride_heat_cost_UI.text = str(layers[6].heat_lvl_next_cost)
		layers[6].tick_rate = 0.6
		ticker_animate(6, pride_ticker)
	if layers[6].heat_lvl == 4:
		$"../PrideLayer/PrideUIToggle/Pride_Temp_0".hide()
		$"../PrideLayer/PrideUIToggle/Pride_Temp_1".hide()
		$"../PrideLayer/PrideUIToggle/Pride_Temp_2".hide()
		$"../PrideLayer/PrideUIToggle/Pride_Temp_3".hide()
		$"../PrideLayer/PrideUIToggle/Pride_Temp_4".show()
		$"../PrideLayer/PrideUIToggle/Pride_Temp_5".hide()
		pride_ticker.tint_progress = Color("#efa03b")
		pride_heat_cost_UI.text = str(layers[6].heat_lvl_next_cost)
		layers[6].tick_rate = 0.4
		ticker_animate(6, pride_ticker)
	if layers[6].heat_lvl >= 5:
		$"../PrideLayer/PrideUIToggle/Pride_Temp_0".hide()
		$"../PrideLayer/PrideUIToggle/Pride_Temp_1".hide()
		$"../PrideLayer/PrideUIToggle/Pride_Temp_2".hide()
		$"../PrideLayer/PrideUIToggle/Pride_Temp_3".hide()
		$"../PrideLayer/PrideUIToggle/Pride_Temp_4".hide()
		$"../PrideLayer/PrideUIToggle/Pride_Temp_5".show()
		pride_ticker.tint_progress = Color("#e65238")
		layers[6].tick_rate = 0.1
		ticker_animate(6, pride_ticker)
		pride_heat_cost_UI.text = "MAX"

func people_die_message():
	pass

#random events
func random_event():
	pass

func add_first_fire():
	fire += 1

#CONVERT SOULS TO FIRE
func _on_lust_fire_pressed() -> void:
	convert_souls_to_fire(0)

func _on_gluttony_fire_pressed() -> void:
	convert_souls_to_fire(1)
	
func _on_greed_fire_pressed() -> void:
	convert_souls_to_fire(2)

func _on_sloth_fire_pressed() -> void:
	convert_souls_to_fire(3)

func _on_wrath_fire_pressed() -> void:
	convert_souls_to_fire(4)

func _on_envy_fire_pressed() -> void:
	convert_souls_to_fire(5)

func _on_pride_fire_pressed() -> void:
	convert_souls_to_fire(6)

func hide_all_layers():
	pass

#buttons to unlock layers
func _on_unlock_lust_pressed() -> void:
	if fire >= lust_unlock_cost:
		layers[0].layer_unlocked = true
		fire -= lust_unlock_cost
		#hide unlock gfx and show layer ui
		$"../GlobalUI/Unlock_Lust".queue_free()
		$"../LustLayer/LustUIToggle".show()
		#hide current head and show next one
		$"../GlobalUI/Heads/HellMakerHead0".queue_free()
		$"../GlobalUI/Heads/HellMakerHead1".show()
		print("lust unlocked")

func _on_unlock_gluttony_pressed() -> void:
	if fire >= gluttony_unlock_cost and layers[0].layer_unlocked == true:
		layers[1].layer_unlocked = true
		fire -= gluttony_unlock_cost
		#hide unlock gfx and show layer ui
		$"../GlobalUI/Unlock_Gluttony".queue_free()
		$"../GluttonyLayer/GluttonyUIToggle".show()
		#hide current head and show next one
		$"../GlobalUI/Heads/HellMakerHead1".queue_free()
		$"../GlobalUI/Heads/HellMakerHead2".show()
		print("gluttony unlocked")

func _on_unlock_greed_pressed() -> void:
	if fire >= greed_unlock_cost and layers[1].layer_unlocked == true:
		layers[2].layer_unlocked = true
		fire -= greed_unlock_cost
		#hide unlock gfx and show layer ui
		$"../GlobalUI/Unlock_Greed".queue_free()
		$"../GreedLayer/GreedUIToggle".show()
		#hide current head and show next one
		$"../GlobalUI/Heads/HellMakerHead2".queue_free()
		$"../GlobalUI/Heads/HellMakerHead3".show()
		print("greed unlocked")
		
func _on_unlock_sloth_pressed() -> void:
	if fire >= sloth_unlock_cost and layers[2].layer_unlocked == true:
		layers[3].layer_unlocked = true
		fire -= sloth_unlock_cost
		#hide unlock gfx and show layer ui
		$"../GlobalUI/Unlock_Sloth".queue_free()
		$"../SlothLayer/SlothUIToggle".show()
		#hide current head and show next one
		$"../GlobalUI/Heads/HellMakerHead3".queue_free()
		$"../GlobalUI/Heads/HellMakerHead4".show()
		print("sloth unlocked")
		
func _on_unlock_wrath_pressed() -> void:
	if fire >= wrath_unlock_cost and layers[3].layer_unlocked == true:
		layers[4].layer_unlocked = true
		fire -= wrath_unlock_cost
		#hide unlock gfx and show layer ui
		$"../GlobalUI/Unlock_Wrath".queue_free()
		$"../WrathLayer/WrathUIToggle".show()
		#hide current head and show next one
		$"../GlobalUI/Heads/HellMakerHead4".queue_free()
		$"../GlobalUI/Heads/HellMakerHead5".show()
		print("wrath unlocked")
		
func _on_unlock_envy_pressed() -> void:
	if fire >= envy_unlock_cost and layers[4].layer_unlocked == true:
		layers[5].layer_unlocked = true
		fire -= envy_unlock_cost
		#hide unlock gfx and show layer ui
		$"../GlobalUI/Unlock_Envy".queue_free()
		$"../EnvyLayer/EnvyUIToggle".show()
		#hide current head and show next one
		$"../GlobalUI/Heads/HellMakerHead5".queue_free()
		$"../GlobalUI/Heads/HellMakerHead6".show()
		print("envy unlocked")
		
func _on_unlock_pride_pressed() -> void:
	if fire >= pride_unlock_cost and layers[5].layer_unlocked == true:
		layers[6].layer_unlocked = true
		fire -= pride_unlock_cost
		#hide unlock gfx and show layer ui
		$"../GlobalUI/Unlock_Pride".queue_free()
		$"../PrideLayer/PrideUIToggle".show()
		#hide current head and show next one
		$"../GlobalUI/Heads/HellMakerHead6".queue_free()
		$"../GlobalUI/Heads/HellMakerHead7".show()
		print("pride unlocked")

func timer_reset(i):
	layers[i].decay_timer.stop()
	layers[i].decay_timer.start()

func heat_lvl_up(i):
	if fire >= layers[i].heat_lvl_cost:
		fire -= layers[i].heat_lvl_cost
		layers[i].heat_lvl += 1
		layers[i].temp_cost_text.text = str(layers[i].heat_lvl_next_cost)
		print("heat lvl up", layers[i].heat_lvl)
		
	if layers[i].heat_lvl == 0:
		layers[i].soul_gen_rate = layers[i].soul_gen_base_rate 
		layers[i].heat_lvl_cost = layers[i].heat_lvl_cost_base_rate
		layers[i].heat_lvl_next_cost = layers[i].heat_lvl_cost_base_rate * HEAT_MULTIPLIERS[0]
		
	if layers[i].heat_lvl == 1:
		layers[i].soul_gen_rate = layers[i].soul_gen_base_rate * HEAT_MULTIPLIERS[0]
		layers[i].heat_lvl_cost = layers[i].heat_lvl_cost_base_rate * HEAT_MULTIPLIERS[0]
		layers[i].heat_lvl_next_cost = layers[i].heat_lvl_cost_base_rate * HEAT_MULTIPLIERS[1]
		
	if layers[i].heat_lvl == 2:
		layers[i].soul_gen_rate = layers[i].soul_gen_base_rate * HEAT_MULTIPLIERS[1]
		layers[i].heat_lvl_cost = layers[i].heat_lvl_cost_base_rate * HEAT_MULTIPLIERS[1]
		layers[i].heat_lvl_next_cost = layers[i].heat_lvl_cost_base_rate * HEAT_MULTIPLIERS[2]
		
	if layers[i].heat_lvl == 3:
		layers[i].soul_gen_rate = layers[i].soul_gen_base_rate * HEAT_MULTIPLIERS[2]
		layers[i].heat_lvl_cost = layers[i].heat_lvl_cost_base_rate * HEAT_MULTIPLIERS[2]
		layers[i].heat_lvl_next_cost = layers[i].heat_lvl_cost_base_rate * HEAT_MULTIPLIERS[3]
		
	if layers[i].heat_lvl == 4:
		layers[i].soul_gen_rate = layers[i].soul_gen_base_rate * HEAT_MULTIPLIERS[3]
		layers[i].heat_lvl_cost = layers[i].heat_lvl_cost_base_rate * HEAT_MULTIPLIERS[3]
		layers[i].heat_lvl_next_cost = layers[i].heat_lvl_cost_base_rate * HEAT_MULTIPLIERS[4]
		
	if layers[i].heat_lvl >= 5:
		layers[i].soul_gen_rate = layers[i].soul_gen_base_rate * HEAT_MULTIPLIERS[4]
		layers[i].heat_lvl_cost = layers[i].heat_lvl_cost_base_rate * HEAT_MULTIPLIERS[4]
		layers[i].heat_lvl_next_cost = 0
		layers[i].heat_lvl = 5
		
	timer_reset(i)
	
func heat_lvl_decay(i):
	layers[i].heat_lvl -= 1

	if layers[i].heat_lvl == 0:
		layers[i].soul_gen_rate = layers[i].soul_gen_base_rate
		layers[i].heat_lvl_next_cost = layers[i].heat_lvl_cost_base_rate * HEAT_MULTIPLIERS[0]

	if layers[i].heat_lvl == 1:
		layers[i].soul_gen_rate = layers[i].soul_gen_base_rate * HEAT_MULTIPLIERS[0]
		layers[i].heat_lvl_next_cost = layers[i].heat_lvl_cost_base_rate * HEAT_MULTIPLIERS[1]

	if layers[i].heat_lvl == 2:
		layers[i].soul_gen_rate = layers[i].soul_gen_base_rate * HEAT_MULTIPLIERS[1]
		layers[i].heat_lvl_next_cost = layers[i].heat_lvl_cost_base_rate * HEAT_MULTIPLIERS[2]

	if layers[i].heat_lvl == 3:
		layers[i].soul_gen_rate = layers[i].soul_gen_base_rate * HEAT_MULTIPLIERS[2]
		layers[i].heat_lvl_next_cost = layers[i].heat_lvl_cost_base_rate * HEAT_MULTIPLIERS[3]

	if layers[i].heat_lvl == 4:
		layers[i].soul_gen_rate = layers[i].soul_gen_base_rate * HEAT_MULTIPLIERS[3]
		layers[i].heat_lvl_next_cost = layers[i].heat_lvl_cost_base_rate * HEAT_MULTIPLIERS[4]

	if layers[i].heat_lvl >= 5:
		layers[i].soul_gen_rate = layers[i].soul_gen_base_rate * HEAT_MULTIPLIERS[4]
		layers[i].heat_lvl_next_cost = 0
		layers[i].heat_lvl = 5
