class_name ItemData
extends Resource

enum SlotType { WEAPON, ARMOR, ACCESSORY }
enum Rarity { COMMON, UNIQUE, LEGENDARY }

@export var id: String
@export var name: String
@export var icon: Texture2D
@export var description: String

@export_group("Game Data")
@export var slot_type: SlotType
@export var rarity: Rarity
@export var required_class: String = "" # 비워두면 공용
@export var stat_bonuses: Dictionary = {} 
# 예: { "attack": 5, "speed": 2 }
