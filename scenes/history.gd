class_name MoveHistory
extends Node

var movementType: String
var currentPosition: Vector2 = Vector2.ZERO
var movementDirection: Vector2 = Vector2.ZERO

func _init(type: String, position: Vector2, direction: Vector2) -> void:
	movementType = type
	currentPosition = position
	movementDirection = direction
	
func isType(type: String) -> bool:
	return movementType == type
