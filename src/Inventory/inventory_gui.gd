extends Control

signal opened
signal closed

var isOpen: bool = false

@onready var inventory: Inventory = preload("res://Inventory/PlayerInventory.tres")
@onready var ItemStackGUIClass = preload("res://Scenes/itemStackGUI.tscn")
@onready var slots: Array = $NinePatchRect/GridContainer.get_children()

func _ready():
	connectSlots()
	inventory.updated.connect(update)
	update()

func connectSlots():
	for Slot in slots:
		var callable = Callable(onSlotClicked)
		callable = callable.bind(Slot)
		Slot.pressed.connect(callable)

func update():
	for i in range(min(inventory.slots.size(), slots.size())):
		var inventorySlot: InventorySlot = inventory.slots[i]
		
		if !inventorySlot.item: continue
		
		var itemStackGUI: ItemStackGUI = slots[i].itemStackGUI
		if !itemStackGUI:
			itemStackGUI = ItemStackGUIClass.instanteiate()
			slots[i].insert(itemStackGUI)
			
		itemStackGUI.inventorySlot = inventorySlot
		itemStackGUI.update()

func open():
	visible = true
	isOpen = true
	opened.emit()
	
func close():
	visible = false
	isOpen = false
	closed.emit()

func onSlotClicked(slot):
	pass
	
