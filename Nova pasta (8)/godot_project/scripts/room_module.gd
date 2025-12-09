extends Node3D

class_name RoomModule

enum State { OFF, STARTING, RUNNING, STALLED }

var state: int = State.OFF
var start_progress: float = 0.0
var start_time: float = 2.0 # seconds to start

signal started
signal stopped

func start_engine() -> void:
    if state != State.OFF:
        return
    state = State.STARTING
    start_progress = 0.0
    set_process(true)

func stop_engine() -> void:
    state = State.OFF
    set_process(false)
    emit_signal("stopped")

func _process(delta: float) -> void:
    if state == State.STARTING:
        start_progress += delta
        if start_progress >= start_time:
            state = State.RUNNING
            set_process(false)
            emit_signal("started")
