extends CharacterBody2D

@export_category("Movimento")
@export var velocidade: float = 250.0
@export var forca_pulo: float = -400.0

var gravidade: float = float(
	ProjectSettings.get_setting("physics/2d/default_gravity")
)


func _physics_process(delta: float) -> void:
	# Gravidade
	if not is_on_floor():
		velocity.y += gravidade * delta

	# Movimento horizontal
	var direcao := Input.get_axis("ui_left", "ui_right")
	velocity.x = direcao * velocidade

	# Pulo
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = forca_pulo

	move_and_slide()
