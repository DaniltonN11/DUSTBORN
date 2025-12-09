# Gerar e rodar a Wiki com MkDocs

Este documento explica como gerar o site estático da wiki usando MkDocs e como visualizar localmente (PowerShell / Windows).

Requisitos:
- Python 3.8+ instalado
- `pip` disponível

Instalação rápida (PowerShell):

```powershell
python -m pip install --upgrade pip
python -m pip install -r ..\mkdocs-requirements.txt
```

Observação: este `requirements` agora inclui `mkdocs-material`. Se preferir apenas o MkDocs padrão, remova `mkdocs-material` do arquivo.

Arquivos adicionais incluídos:

- `wiki/assets/logo.svg` — placeholder do logo usado pelo tema Material.
- `wiki/assets/extra.css` — estilos adicionais carregados via `extra_css`.
- `wiki/assets/extra.js` — script extra carregado via `extra_javascript`.

Se você quiser usar fontes do Google (opcional para o tema Material), instale as fontes localmente ou ajuste o `mkdocs.yml` para carregar via CDN.

Servir localmente (preview):

```powershell
mkdocs serve
```

O comando acima inicia um servidor local (por padrão: http://127.0.0.1:8000) com live-reload. Com o tema Material, o live-reload também atualiza os estilos.

Gerar site estático (build):

```powershell
mkdocs build --clean
```

Arquivo gerado: `site/` no root do projeto. Pode ser hospedado em GitHub Pages ou outro host estático.

Observações:
- O `mkdocs.yml` usa `docs_dir: wiki` para apontar para os arquivos Markdown existentes.
- Se preferir tema Material, instale `mkdocs-material` e ajuste `mkdocs.yml` (requer dependência adicional).
