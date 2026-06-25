@tool
extends ParallaxLayer

@export var stars: Sprite2D

func _ready() -> void:
	motion_mirroring = stars.get_rect().size
