# UI e Wireframes

Local dos arquivos de UI: `wireframes/`.

Inclui:
- `hud_wireframe.svg` / `hud_hifi.svg`
- `colossus_panel_wireframe.svg` / `colossus_panel_hifi.svg`
- `inventory_wireframe.svg` / `inventory_hifi.svg`
- `mockup_interactive.html` — visualizador que exporta SVGs para PNG.

Recomendações de implementação:
- Modularize o HUD em componentes: `HUD` (CanvasLayer), `ColossusPanel` (Control), `Inventory` (GridContainer).
- Exponha IDs e signals em cada componente para testes (ex: `signal engine_started(room_name)`).
- Use uma camada de dados (viewmodel) para manter a lógica separada da visualização.

Wireframes contém hotspots básicos; atualizar IDs no HTML para mapear ações reais.
