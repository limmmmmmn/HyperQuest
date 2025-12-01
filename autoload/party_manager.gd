extends Node

# 파티 상태
var gold: int = 0
var xp: int = 0
var current_level: int = 1

# 데이터 저장소
var inventory: Array[ItemData] = [] # 획득한 아이템들 [cite: 32]
var party_members: Array[HeroData] = [] # 현재 영웅들
# 장비 현황: { "hero_id": { SlotType.WEAPON: ItemData, ... } }
var equipped_items: Dictionary = {} [cite: 32]

func _ready():
	# 테스트용 초기화 (나중에 삭제)
	pass

# --- 장비 시스템 핵심 로직 ---

# 1. 장비 착용 함수 [cite: 35]
func equip_item(hero_id: String, item: ItemData) -> bool:
	# 해당 영웅 찾기
	var hero = _get_hero_by_id(hero_id)
	if not hero: return false
	
	# 직업 제한 체크 [cite: 154]
	if item.required_class != "" and item.required_class != hero.class_name:
		print("직업이 맞지 않습니다!")
		return false
	
	# 장비 슬롯 데이터 구조 초기화
	if not equipped_items.has(hero_id):
		equipped_items[hero_id] = {}
		
	# 기존 장비가 있다면 인벤토리로 복귀 (구현 생략, 교체 로직)
	equipped_items[hero_id][item.slot_type] = item
	SignalBus.party_updated.emit()
	return true

# 2. 최종 스탯 계산 (기본 스탯 + 아이템 보너스) [cite: 36]
func calculate_total_stats(hero: HeroData) -> Dictionary:
	var total_stats = {
		"max_hp": hero.max_hp,
		"attack": hero.attack,
		"defense": hero.defense,
		"speed": hero.speed,
		"atb_rate": hero.atb_rate
	}
	
	# 장착 아이템이 없으면 기본 스탯 반환
	if not equipped_items.has(hero.id):
		return total_stats
		
	# 장착된 아이템들의 스탯 보너스 합산
	var hero_gear = equipped_items[hero.id]
	for slot in hero_gear:
		var item = hero_gear[slot] as ItemData
		for stat_name in item.stat_bonuses:
			if total_stats.has(stat_name):
				total_stats[stat_name] += item.stat_bonuses[stat_name]
				
	return total_stats

# 3. 최강 장비 자동 장착 (핵심 로직) [cite: 37, 68]
func auto_equip_best_gear(hero_id: String):
	var hero = _get_hero_by_id(hero_id)
	if not hero: return

	# 슬롯별로 인벤토리 검색
	for slot in ItemData.SlotType.values():
		var best_item: ItemData = null
		var max_score = -1
		
		# 현재 장착 중인 아이템도 후보에 포함
		if equipped_items.has(hero_id) and equipped_items[hero_id].has(slot):
			best_item = equipped_items[hero_id][slot]
			max_score = _calculate_item_score(best_item)

		# 인벤토리 뒤지기
		for item in inventory:
			if item.slot_type == slot:
				# 직업 제한 체크
				if item.required_class != "" and item.required_class != hero.class_name:
					continue
				
				var score = _calculate_item_score(item)
				if score > max_score:
					max_score = score
					best_item = item
		
		# 더 좋은 걸 찾았으면 장착
		if best_item:
			equip_item(hero_id, best_item)
			# 인벤토리 처리는 생략 (실제 구현에선 인벤토리에서 제거 로직 필요)
			print(hero.name + "에게 " + best_item.name + " 자동 장착 완료!")

# 아이템 점수 계산 (단순 공격력 합산 예시)
func _calculate_item_score(item: ItemData) -> int:
	var score = 0
	score += item.stat_bonuses.get("attack", 0) * 10
	score += item.stat_bonuses.get("speed", 0) * 5
	score += item.stat_bonuses.get("defense", 0) * 2
	return score

# 유틸리티: ID로 영웅 찾기
func _get_hero_by_id(id: String) -> HeroData:
	for h in party_members:
		if h.id == id: return h
	return null
