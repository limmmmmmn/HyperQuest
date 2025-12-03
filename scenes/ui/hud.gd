extends CanvasLayer

func _ready():
	# 메뉴 버튼 누르면 상태창 열기
	$MenuButton.pressed.connect(_on_menu_button_pressed)

func _on_menu_button_pressed():
	# 게임 매니저에게 상태창 열라고 신호 보냄
	GameManager.show_status_screen()
