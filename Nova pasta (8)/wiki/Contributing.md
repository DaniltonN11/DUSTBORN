# Contributing

Padrões de contribuição e fluxo de trabalho:

- Branching: `main` para releases; `dev` para integração; crie branches `feature/<nome>` para features.
- Commits: mensagem breve e descritiva. Formato sugerido: `tipo(scope): descrição curta` (ex: `feat(godot): add room_module state machine`).
- Pull Requests: inclua descrição do que foi feito, arquivos alterados e passos para testar.
- Code review: pelo menos 1 reviewer técnico para features, 1 reviewer de design para UI/arte.
- Tests: adicione testes automatizados onde possível (scripts de smoke/local). Para Godot, documente passos manuais de teste em `wiki/HowToRun.md`.

Padronização de arquivos:
- Coloque cenas e scripts do Godot em `godot_project/`.
- Assets grandes em `art/` ou `assets/` (se for adicionar ao repositório), seguindo `assets_by_sprint.csv`.

Contato:
- Abra uma issue para grandes mudanças ou crie uma tarefa no backlog.
