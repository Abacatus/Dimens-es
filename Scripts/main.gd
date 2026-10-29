extends Node2D

@export_category("Dimensoes")

@export var dimensoes: Array[Node2D] = []

@export_range(0, 20, 1)
var dimensao_inicial: int = 0

var dimensao_atual: int = 0

var configuracoes_originais: Dictionary = {}


func _ready() -> void:
	if dimensoes.is_empty():
		push_warning("Nenhuma dimensao foi adicionada.")
		return

	dimensao_atual = clampi(
		dimensao_inicial,
		0,
		dimensoes.size() - 1
	)

	for dimensao in dimensoes:
		if dimensao != null:
			guardar_configuracoes(dimensao)

	atualizar_dimensoes()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("trocar_dimensao"):
		trocar_dimensao()


func trocar_dimensao() -> void:
	if dimensoes.is_empty():
		return

	dimensao_atual = (dimensao_atual + 1) % dimensoes.size()

	atualizar_dimensoes()

	print("Dimensao atual: ", dimensoes[dimensao_atual].name)


func atualizar_dimensoes() -> void:
	for i in range(dimensoes.size()):
		var dimensao: Node2D = dimensoes[i]

		if dimensao == null:
			continue

		var ativa: bool = i == dimensao_atual

		dimensao.visible = ativa
		aplicar_estado_fisico(dimensao, ativa)


func guardar_configuracoes(no: Node) -> void:
	if no is CollisionObject2D:
		configuracoes_originais[no] = {
			"collision_layer": no.collision_layer,
			"collision_mask": no.collision_mask
		}

		if no is Area2D:
			configuracoes_originais[no]["monitoring"] = no.monitoring
			configuracoes_originais[no]["monitorable"] = no.monitorable

	if no is TileMapLayer:
		configuracoes_originais[no] = {
			"collision_enabled": no.collision_enabled
		}

	for filho in no.get_children():
		guardar_configuracoes(filho)


func aplicar_estado_fisico(raiz: Node, ativo: bool) -> void:
	configurar_fisica_recursiva(raiz, ativo)


func configurar_fisica_recursiva(no: Node, ativo: bool) -> void:
	if configuracoes_originais.has(no):
		var original: Dictionary = configuracoes_originais[no]

		if no is CollisionObject2D:
			if ativo:
				no.collision_layer = original["collision_layer"]
				no.collision_mask = original["collision_mask"]
			else:
				no.collision_layer = 0
				no.collision_mask = 0

		if no is Area2D:
			if ativo:
				no.monitoring = original["monitoring"]
				no.monitorable = original["monitorable"]
			else:
				no.monitoring = false
				no.monitorable = false

		if no is TileMapLayer:
			if ativo:
				no.collision_enabled = original["collision_enabled"]
			else:
				no.collision_enabled = false

	for filho in no.get_children():
		configurar_fisica_recursiva(filho, ativo)
