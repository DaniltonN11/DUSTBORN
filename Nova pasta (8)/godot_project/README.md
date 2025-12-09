Godot prototype skeleton for Dustborn Colossus

Requirements:
- Godot 4.1+

Quick start:
1. Open Godot and choose "Import" -> select folder `godot_project` or open the project root.
2. Open `scenes/Colossus.tscn` to view the placeholder Colossus scene.
3. Play the scene to see placeholder meshes.

Notes:
- Scripts are stubs implementing simple state machines. Replace with networked RPCs and server-side validation when adding multiplayer.
- `RoomModule`, `EngineSystem`, `TaskManager` are minimal and intended as a starting point for prototyping.
