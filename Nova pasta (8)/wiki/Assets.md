# Assets e Pipeline

Arquivo principal de inventário de assets: `assets_by_sprint.csv` (modelos, VFX, SFX, UI, prioridades e estimativas).

Recomendações do pipeline:
- Placeholder -> Greybox -> Authoring PBR -> LODs -> VFX/Audio integrada.
- Nomeação: `colossus/<part>/<lod>/<part>_v001.fbx` ou `art/characters/<name>/_v001.glb`.
- Texturas: 4K master para elementos grandes (body), 1–2K para props menores.

Onde estão os wireframes/UI: `wireframes/` — contém SVGs e `mockup_interactive.html` para export.

Checklist para entrega de asset:
- FBX/GLB exportado, pivôs corretos, escala documentada.
- Material PBR com parâmetros exportados (albedo/metallic/roughness/normal).
- LODs nomeados e TestScene com referência.
