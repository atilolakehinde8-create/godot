extends CharacterBody2D

# Movement constants
const SPEED := 300
const JUMP_VELOCITY := -400
var gravity := 980

# AnimatedSprite2D
@onready var anim: AnimatedSprite2D = $AnimatedSprite2D

func _ready():
	if anim:
		anim.play("Idle")

func _physics_process(delta):
	 #Apply gravity
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		if velocity.y > 0:
			velocity.y = 0

	# Jump
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		if anim:
			anim.play("Jump")

	# Horizontal movement
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction != 0:
		velocity.x = direction * SPEED
		if anim:
			anim.flip_h = direction < 0
			if is_on_floor() and anim.animation != "RUN":
				anim.play("Run")
	else:
		# Slow down smoothly
		velocity.x = move_toward(velocity.x, 0, SPEED)
		if is_on_floor() and anim and anim.animation != "IDLE":
			anim.play("Idle")

	# Move the player
	move_and_slide()
