class_name EnemyData
extends Resource

@export var id: String
@export var name: String
@export var sprite_frames: SpriteFrames # 애니메이션용
@export var is_elite: bool = false 

@export_group("Combat Stats")
@export var max_hp: int = 50
@export var attack: int = 5
@export var speed: int = 8
@export var atb_rate: float = 0.8 # 적은 보통 플레이어보다 조금 느리게 설정
