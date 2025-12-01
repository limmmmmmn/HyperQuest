extends CharacterBody2D

@export var speed: float = 150.0

func _physics_process(delta):
	# 입력 벡터 가져오기 (ui_up, ui_down, ui_left, ui_right)
	var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	if direction:
		velocity = direction * speed
	else:
		velocity = velocity.move_toward(Vector2.ZERO, speed)

	move_and_slide()
