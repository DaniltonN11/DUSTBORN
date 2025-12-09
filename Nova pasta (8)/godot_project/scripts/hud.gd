extends CanvasLayer

class_name HUD

onready var label_status := $UI/Label_Status

func _ready():
    update_status("Ready")

func update_status(text: String) -> void:
    if label_status:
        label_status.text = "Colossus: %s".format(text)
