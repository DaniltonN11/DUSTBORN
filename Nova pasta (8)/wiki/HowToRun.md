# How To Run (Godot) — Passos Rápidos

Requisitos:
- Godot 4.1 ou superior.

Abrir o protótipo:
1. Abra Godot, clique em "Open" e selecione a pasta `c:/Users/User/Desktop/Nova pasta (8)/godot_project`.
2. No FileSystem, navegue até `scenes/Colossus.tscn` e dê duplo clique para abrir.
3. Pressione o botão Play (F5) para executar a cena.

Testes básicos:
- Use o Remote Inspector para chamar `start_engine()` em um `RoomModule` e verificar a transição para `RUNNING`.
- Abra o console Output para ver prints (adicionar `print()` nos scripts se precisar de debug).

Notas sobre multiplayer:
- O esqueleto atual contém stubs; para testes em rede adicione `@rpc` e configure `MultiplayerPeer` (ENet/HighLevelMultiplayerPeer).
