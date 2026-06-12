extends Control

@onready var dialogue_box: DialogueBox = $MarginContainer/DialogueBox
@onready var line_edit: LineEdit = $MarginContainer/LineEdit

var Charactors: Dictionary = {
	Vector3(-1, 0, 0): "Tree",
	Vector3(0, 0, 0): "Rock",
	Vector3(0, 0, 1): "Nice",
	Vector3(0, 0, 2): "Cat",
}

var Dialogs: Dictionary = {
	"Rock": [-1, ["Talking Rock"]],
	"Tree": [-1, ["Practice Talking"]]
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.wakeUp.connect(wakeUp)
	Global.talk.connect(talk)
	
func wakeUp() -> void:
	dialogue_box.start("Whats my Name")
	
func talk(atlas: Vector2, id: int) -> void:
	var charactor: String = Charactors.get(Vector3(atlas.x, atlas.y, id))
	var dialogHolder: Array[Variant] = Dialogs.get(charactor)
	if dialogHolder[1].size() > dialogHolder[0]:
		var dialog: String = dialogHolder[1][0 if dialogHolder[0] < 0 else dialogHolder[0]]
		if dialogHolder[0] >= 0:
			dialogHolder[0] += 1
		dialogue_box.start(dialog)
	

func _on_dialogue_box_dialogue_signal(value: String) -> void:
	dialogue_box.hide()
	if value == "getName":
		line_edit.show()
		await line_edit.text_submitted
		dialogue_box.start("Whats my Name Continue")
	if value == "PracticeTalk":
		dialogue_box.variables.set("PracticeTalk", true)
		print(dialogue_box.variables.get("PracticeTalk"))
	if value == "RockTalk":
		Dialogs.get("Rock")[0] = 1


func _on_line_edit_text_submitted(new_text: String) -> void:
	dialogue_box.variables.set("Player", new_text)
	line_edit.hide()
	dialogue_box.show()


func _on_dialogue_box_dialogue_started(_id: String) -> void:
	Global.isActionsPaused = true


func _on_dialogue_box_dialogue_ended() -> void:
	Global.isActionsPaused = false


func _on_draw() -> void:
	mouse_filter = Control.MOUSE_FILTER_STOP


func _on_hidden() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
