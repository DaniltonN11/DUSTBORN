extends Node3D

@tool
class_name ColossusController

# High-level Colossus controller skeleton. Server-authoritative stubs.
@onready var rooms := $Rooms.get_children()

func _ready():
    # discover room modules
    rooms = []
    if has_node("Rooms"):
        for child in $Rooms.get_children():
            rooms.append(child)

func request_start_engine(room_name: String) -> void:
    # Client call stub: in multiplayer, client should call an RPC to request this
    # Replace with @rpc in a networked project and perform server-side validation
    var room = _find_room(room_name)
    if room:
        room.start_engine()

func _find_room(name: String):
    for r in rooms:
        if r.name == name:
            return r
    return null
