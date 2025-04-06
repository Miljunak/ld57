extends Node2D
class_name Bazunia

signal base_entered
signal base_exited

var player_in_zone := false
@onready 
var my_ui = $baza_gui  # Or get_node("MyUI") if different path
@onready 
var keyHint = $keyHint  # Or get_node("MyUI") if different path

var money = 500;

func set_moneys(val: int) -> void:
	if val != money:
		money = val
		$baza_gui/Control/Upgrades/moneysDisplayer.text =  "$ %d"%[money]
		

func _ready():
	my_ui.visible = false
	$baza_gui/Control/Upgrades/moneysDisplayer.text = "$ %d"%[money]
	$baza_gui/Control/Upgrades/engine/upgradeProgress.max_value = len(engine_upgrades)
	$baza_gui/Control/Upgrades/throtle_speed/upgradeProgress.max_value = len(throtel_upgrades)
	$baza_gui/Control/Upgrades/oxygenTank/upgradeProgress.max_value = len(oxygen_upgrades)
	$baza_gui/Control/Upgrades/ballast_speed/upgradeProgress.max_value = len(ballast_upgrade)
	push_warning("NO SUCHA test")

func load_inv():
	var itList : ItemList= $baza_gui/Control/Items/ItemList
	itList.clear()
	var colMod : CollectorModule = playerRef.get_node("CollectorModule")
	var sum = 0
	for it in colMod.inventory:
		itList.add_item("%s | %d" % [it, itemsValue[it]])
		sum += itemsValue[it]
	$baza_gui/Control/Items/TotalPriceTag.text = "+ %d$" % [sum]
	
func _on_area_entered(body: Node2D) -> void:
	if body.name == "Submariner":
		player_in_zone = true
		my_ui.visible = false
		keyHint.visible = true
		playerRef = body as Submariner
		inv = playerRef.get_node("CollectorModule")
		load_inv()

func _on_area_exited(body: Node2D) -> void:
	if body.name == "Submariner":
		player_in_zone = false
		my_ui.visible = false
		base_exited.emit()
		keyHint.visible = false
		
var playerRef : Submariner = null
var inv : CollectorModule = null

func _process(delta):
	if player_in_zone and Input.is_action_just_pressed("interact"):
		my_ui.visible = !my_ui.visible
		if my_ui.visible:
			base_entered.emit()
		
var engine_upgrades = [{"maxSpeedBonus":1,"cost":100},
					   {"maxSpeedBonus":1,"cost":200},
					   {"maxSpeedBonus":1,"cost":300},
					   {"maxSpeedBonus":1,"cost":400}]
var currentEngine = 0
func _on_engine_upgrade() -> void:
	var upgrade_cost = engine_upgrades[currentEngine]["cost"]
	if money > upgrade_cost:
		playerRef.engineUpgradeMaxSpeed += engine_upgrades[currentEngine]["maxSpeedBonus"]
		currentEngine+=1
		set_moneys(money-upgrade_cost)
		$baza_gui/Control/Upgrades/engine/upgradeProgress.value+=1

#Upgrade zmieniajacy jak szybko mozna ta dzwignie przyspieszenia przesunac
var throtel_upgrades = [{"throtel_change_bonus":.2,"cost":100},
					   {"throtel_change_bonus":.1,"cost":200},
					   {"throtel_change_bonus":.1,"cost":300},
					   {"throtel_change_bonus":.05,"cost":300},
					   {"throtel_change_bonus":.1,"cost":400}]
var currentThrotel = 0

func _on_throtel_speed() -> void:
	var upgrade_cost = throtel_upgrades[currentThrotel]["cost"]
	if money > upgrade_cost:
		playerRef.throtelChangeSpeedBonus += throtel_upgrades[currentThrotel]["throtel_change_bonus"]
		currentThrotel+=1
		set_moneys(money-upgrade_cost)
		$baza_gui/Control/Upgrades/throtle_speed/upgradeProgress.value+=1

var itemsValue = {"shoe":10,"aquamarine":50,"amethyst":100,"gold":200,"ruby":500}



func sellItems() -> void:
	var sellSum = 0
	for item in inv.inventory:
		if item in itemsValue.keys():
			sellSum += itemsValue[item]
		else:
			push_warning("NO SUCHA ITEM ", item)
	inv.inventory.clear()
	load_inv()
	set_moneys(money+sellSum)
	

var oxygen_upgrades = [{"bonus_max_oxygen":20,"cost":100},
					   {"bonus_max_oxygen":25,"cost":200},
					   {"bonus_max_oxygen":25,"cost":300},
					   {"bonus_max_oxygen":25,"cost":300},
					   {"bonus_max_oxygen":25,"cost":400}]
var current_oxygen = 0

func _on_oxygen_upgraded() -> void:
	var upgrade_cost = oxygen_upgrades[current_oxygen]["cost"]
	if money > upgrade_cost:
		playerRef.upgrade_oxygen(oxygen_upgrades[current_oxygen]["bonus_max_oxygen"])
		current_oxygen+=1
		set_moneys(money-upgrade_cost)
		$baza_gui/Control/Upgrades/oxygenTank/upgradeProgress.value+=1

var ballast_upgrade = [{"ballast_upgrade_bonus":.2,"cost":100},
					   {"ballast_upgrade_bonus":.1,"cost":200},
					   {"ballast_upgrade_bonus":.1,"cost":300},
					   {"ballast_upgrade_bonus":.05,"cost":300},
					   {"ballast_upgrade_bonus":.1,"cost":400}]
var current_ballast = 0
func _on_ballast_pump_upgraded() -> void:
	var upgrade_cost = throtel_upgrades[current_ballast]["cost"]
	if money > upgrade_cost:
		playerRef.BUOYANCY_CHANGE_SPEED += ballast_upgrade[current_ballast]["ballast_upgrade_bonus"]
		current_ballast+=1
		set_moneys(money-upgrade_cost)
		$baza_gui/Control/Upgrades/ballast_speed/upgradeProgress.value+=1
