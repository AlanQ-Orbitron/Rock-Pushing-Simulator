@tool
extends Control


@export var hSpacing: int = 1
@export var vSpacing: int = 10
@export var waveScale: float = 0.2

@export_category("margins")
@export var marginLeft: int = 0
@export var marginRight: int = 0
@export var marginUp: int = 0
@export var marginDown: int = 0

@onready var line_2d: Line2D = $Line2D
@onready var screenSize: Vector2i = get_viewport().get_visible_rect().size

var aComponent: int = randi_range(0, 8)
var bComponent: int = randi_range(0, 4)
var points: PackedVector2Array

func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	drawWaves()

func drawWaves() -> void:
	var amountPoints: int = (screenSize.x / hSpacing) + 1
	points = []
	for point: int in range(amountPoints):
		points.append(Vector2(point * hSpacing, (screenSize.y / 2.0 ) + function(point * waveScale, Time.get_ticks_msec() / 500.0) * vSpacing))
	line_2d.points = points

func function(input: float, time: float, control: bool = true) -> float:
	return sin(input + time) + sin(aComponent + (bComponent * input) + time) + sin((2 * aComponent) + (2 * bComponent * input) + time)
