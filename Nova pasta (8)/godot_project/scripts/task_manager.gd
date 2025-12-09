extends Node

class_name TaskManager

class Task:
    var id: String
    var progress: float = 0.0
    var goal: float = 1.0

    func _init(_id: String, _goal: float = 1.0):
        id = _id
        goal = _goal

var tasks: Dictionary = {}

func create_task(id: String, goal: float = 1.0) -> void:
    var t = Task.new(id, goal)
    tasks[id] = t

func update_task(id: String, delta: float) -> void:
    if not tasks.has(id):
        return
    tasks[id].progress += delta
    if tasks[id].progress >= tasks[id].goal:
        tasks.erase(id)

func get_progress(id: String) -> float:
    if not tasks.has(id):
        return 0.0
    return tasks[id].progress / tasks[id].goal
