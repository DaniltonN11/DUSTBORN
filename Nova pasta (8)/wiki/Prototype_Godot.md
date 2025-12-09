# Protótipo — Godot

O repositório já contém um esqueleto Godot em `godot_project/` criado para Godot 4.1+.

Conteúdo gerado:
- `scenes/Colossus.tscn` — cena raiz com placeholder `Body` e instância de `RoomModule`.
- `scenes/RoomModule.tscn` — módulo de sala com script `room_module.gd` (máquina de estados).
- `scenes/HUD.tscn` — HUD simples com `hud.gd`.
- `scripts/colossus_controller.gd`, `engine_system.gd`, `task_manager.gd` — stubs GDScript.
- `README.md` no diretório `godot_project/` com instruções rápidas para abrir o projeto.

Como testar localmente:
1. Abra o Godot 4.1 e importe `godot_project` ou abra a pasta como projeto.
2. Abra `scenes/Colossus.tscn` e pressione Play.
3. Use o editor para selecionar um `RoomModule` na árvore e chame `start_engine()` via Remote Inspector para ver a transição de estado.

Próximos passos (recomendados):
- Adicionar `@rpc` para chamadas seguras entre clientes e servidor.
- Mapear entrada dos jogadores para funções em `ColossusController`.
- Conectar sinais (`started`/`stopped`) para atualizar o `HUD`.
