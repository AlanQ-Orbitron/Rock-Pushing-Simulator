extends Control

@export var dialog_data: SproutyDialogsDialogueData
@onready var dialog_player: DialogPlayer

var amountTalked: int

var dialogs: Dictionary = {
	[Vector2i(0, 0), 0] : "TALKING_ROCK",
	[Vector2i(1, 0), 0] : "PEN_PAL"
}

func _ready() -> void:
	Global.connect("talk", talk)

func talk(atlas: Vector2i, id: int) -> void:
	if dialog_player != null:
		return
	amountTalked += 1
	dialog_player = DialogPlayer.new()
	add_child(dialog_player)
	dialog_player.set_dialog(dialog_data, dialogs.get([atlas, id]))
	dialog_player.start()
