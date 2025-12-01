class_name HeroData
extends Resource

@export var id: String
@export var name: String
@export var icon: Texture2D
@export var class_name: String # 예: "Warrior", "Mage"

@export_group("Base Stats")
@export var max_hp: int = 100
@export var attack: int = 10
@export var defense: int = 0
@export var speed: int = 10     # 선공권 결정 [cite: 29]
@export var atb_rate: float = 1.0 # 공격 빈도 (높을수록 빠름) [cite: 29]

@export_group("Synergy")
@export var synergy_tags: Array[String] = [] # 예: ["Bald", "Fisherman"] [cite: 28]
