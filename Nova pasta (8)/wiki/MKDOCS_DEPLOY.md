# Deploy da Wiki para GitHub Pages

Este documento descreve como a wiki é automaticamente publicada no GitHub Pages e como configurar deploy manual/local.

Automático (GitHub Actions)

- Um workflow `/.github/workflows/deploy_mkdocs.yml` foi adicionado. Ele roda quando há push na branch `main`, gera o site com MkDocs e publica a pasta `site/` na branch `gh-pages` usando o token do GitHub Actions.
- Pré-requisitos: o repositório deve permitir Actions (padrão) e não precisa de secrets adicionais já que o workflow usa `${{ secrets.GITHUB_TOKEN }}`.
- Após o primeiro deploy, configure GitHub Pages nas configurações do repositório para servir a partir da branch `gh-pages` (Settings → Pages → Branch: `gh-pages`).

Deploy manual (local)

1. Instale dependências:

```powershell
python -m pip install --upgrade pip
python -m pip install -r mkdocs-requirements.txt
```

2. Gerar e publicar com o utilitário `mkdocs` (útil para testes locais):

```powershell
mkdocs build --clean
mkdocs gh-deploy --force
```

Observações:

- `mkdocs gh-deploy` cria e publica automaticamente na branch `gh-pages` (recomendado usar somente para testes locais quando necessário).
- O workflow CI é a forma recomendada para deploy contínuo (push → publicação automática).

Configurar a URL do site

- Atualize `mkdocs.yml` com `site_url: "https://<your-org>.github.io/<your-repo>/"` para permitir links absolutos e correto Open Graph.

Algolia / Pesquisa Avançada

- Para pesquisa hospedada (Algolia), é possível configurar `theme.extra` e fornecer `algolia` keys em `mkdocs.yml`. Não armazene chaves públicas secretas no repositório sem revisão.
