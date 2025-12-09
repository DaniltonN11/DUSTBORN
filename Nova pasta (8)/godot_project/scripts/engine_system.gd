extends Node

class_name EngineSystem

var modules: Array = []

func _ready():
    modules.clear()
    for child in get_children():
        if child is RoomModule:
            modules.append(child)

func start_all() -> void:
    for m in modules:
        m.start_engine()

func stop_all() -> void:
    for m in modules:
        m.stop_engine()
