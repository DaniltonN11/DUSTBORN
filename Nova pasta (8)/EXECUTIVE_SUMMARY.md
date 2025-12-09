# Resumo Executivo — Projeto Dustborn

**Data**: 16 de Novembro de 2025  
**Status**: Em planejamento — pronto para kickoff de desenvolvimento  
**Preparado para**: Stakeholders, Liderança, Equipe de Desenvolvimento

---

## 1. Resumo do Projeto

**Dustborn** é um jogo de **survival pós-apocalíptico em mundo aberto** com foco em **cooperação multiplayer** (3–6 jogadores). O conceito central é gerenciar um **veículo colossal móvel** (o "Colosso") que funciona como base, meio de transporte e hub social, enquanto os jogadores exploram zonas mortais, coletam recursos e progridem até atravessar uma muralha final que divide o mundo.

### Principais Diferenciais

- **Veículo cooperativo modular**: Colosso com cômodos interconectados (motor, oficina, arsenal, dormitórios) que podem ser danificados e reparados.
- **Tarefas simultâneas**: Ligação do motor requer 3 jogadores em etapas sequenciais; reparos e crafting acontecem em paralelo.
- **Inventário físico inspirado em Tarkov**: Grid com peso/volume; itens podem ser perdidos ou roubados.
- **Clima dinâmico**: Tempestades de poeira, radiação solar, congelamento — afetam visibilidade, saúde do motor e degradação de peças.
- **Progressão por zona**: 6 zonas com inimigos únicos, facções e chefes; cada zona só se abre após atingir objetivos na anterior.

---

## 2. Visão Geral do Escopo

### MVP (Produto Mínimo Viável) — 12 Semanas

| Aspecto | Escopo MVP | Deixado para v1.1+ |
|--------|-----------|-------------------|
| **Mapa** | 2 zonas (Deserto Inicial + Cânions) | Cidade Submersa, Ferrovias, Radioativa, Muralha |
| **Colosso** | 3 cômodos (Motor, Oficina, Dormitório) | 4 cômodos adicionais, defesas externas |
| **Jogadores** | 3–4 (roles: Piloto, Engenheiro, Atirador) | Scavenger, classe-specific abilities |
| **Inimigos** | 2 tipos (Dust Reavers, Carcinos) | Mecatrons, Aspidianos, Tempestade Viva |
| **Crafting** | Básico (reparos, consumíveis) | Upgrades complexos, modificações de armas |
| **Economia** | Barter simples, inventário compartilhado | Sistema de credits, leilões, seguros |

### Fora do MVP (Planejado para Updates)

- [ ] Modo solo campaña completa (Kael).
- [ ] PvP/Facções com consequências de reputação.
- [ ] Sistema completo de habilidades e perks.
- [ ] Evento dinâmico "Tempestade Viva".
- [ ] Cross-save e seasonal content.

---

## 3. Timeline (Recomendado)

### Fase 1: Prototipagem (4 semanas)
- **Sprint 1** (2 sem): Motor, movimento, rede básica.
- **Sprint 2** (2 sem): Multiplayer, roles, tarefas cooperativas.
- **Deliverable**: Build jogável com 3 players, motor funcionando, Colosso movendo.

### Fase 2: Conteúdo (5 semanas)
- **Sprint 3** (3 sem): Crafting, dano, clima básico, inimigos.
- **Sprint 4** (2 sem): Zona inicial completa, miniboss.
- **Deliverable**: Primeira zona jogável com loop de survival completo.

### Fase 3: Polishing (3 semanas)
- **Sprint 5** (2 sem): Otimização, testes de carga, bug fixes.
- **Sprint 6** (1 sem): Balanceamento, feedback do playtesting.
- **Deliverable**: Build pronta para closed alpha/beta.

**Total**: 12 semanas (~3 meses)

---

## 4. Tamanho da Equipe Recomendado

### Núcleo Mínimo (MVP — 5–7 pessoas)

- **1 Lead Técnico** (arquitetura, rede, performance).
- **2 Programmers (Gameplay + Engine)** (Colosso, inimigos, IA).
- **1 Programmer (Rede)** (sincronização, servidor).
- **1 Designer de Sistemas** (balanceamento, loops).
- **1–2 Artistas 3D** (Colosso, inimigos, ambiente).
- **1 Sound Designer / Compositor** (loops, alertas, música).
- **0.5–1 QA / Tester** (testes de coop, bugs).

### Escalabilidade Pós-MVP

- Adicionar 1–2 artistas para mais conteúdo visual.
- Contratar narrative designer para campanhas.
- Expandir rede de servidores (DevOps).

---

## 5. Stack Técnico Recomendado

| Componente | Escolha | Justificativa |
|-----------|--------|--------------|
| **Engine** | Unity 2022 LTS+ | Comunidade grande, documentação, prototipagem rápida. Alternativa: Unreal (mais pesado). |
| **Rede** | Netcode for GameObjects | Built-in, bem documentado. Alternativa: Photon PUN2 (mais overhead). |
| **Banco de Dados** | Firebase ou PlayFab | Backend gerenciado para logins, saves, analytics. |
| **Servidores** | AWS EC2 ou Azure | Para servidor dedicado multiplayer. Custo: ~$100–300/mês em produção. |
| **CI/CD** | GitHub Actions + Unity Cloud Build | Builds automáticos, testes automatizados. |
| **Monetização** | TBD | F2P com cosmetics ou Premium. Decidir pós-MVP. |

---

## 6. Orçamento Estimado (MVP)

### Custos de Desenvolvimento (12 semanas, equipe de 6 pessoas)

| Item | Custo Estimado (USD) |
|------|-------------------|
| Salários (6 pessoas × 12 sem × $800/sem médio) | $57,600 |
| Software (Unity Pro, servidores, ferramentas) | $2,000 |
| Servidores multiplayer (testing) | $1,500 |
| Audio (compositor, SFX library) | $2,000 |
| **Total** | **~$63,100** |

### Custos Pós-Lançamento (Anual)

| Item | Custo Estimado (USD) |
|------|-------------------|
| Servidores produção (escalável) | $3,000–5,000/mês |
| Manutenção & suporte | $2,000–3,000/mês |
| Updates & novos conteúdos | $5,000–10,000/mês |

---

## 7. Riscos Principais

### Risco 1: Sincronização Multiplayer Instável
- **Impacto**: Alto (impossibilita teste cooperativo).
- **Probabilidade**: Média.
- **Mitigação**:
  - Testar com Netcode Profiler regularmente.
  - Implementar buffering de estado e replay de ações.
  - Servidor autoritário desde o início (não client-authoritative).

### Risco 2: Performance em 6 Jogadores
- **Impacto**: Alto (gameloop não é viável).
- **Probabilidade**: Média-Alta (Colosso é complexo).
- **Mitigação**:
  - Implementar LOD (Level of Detail) cedo.
  - Object pooling para inimigos e projecteis.
  - Profiling contínuo (Unity Profiler).
  - Considerar servidor dedicado vs P2P conforme necessário.

### Risco 3: Gameplay Imbalanceado (Colosso muito frágil/forte)
- **Impacto**: Médio (afeta diversão).
- **Probabilidade**: Alta (mecânicas novas).
- **Mitigação**:
  - Playtest com equipe interna regularmente (weekly).
  - Feedback de closed beta cedo.
  - Dados de telemetria (sucesso/falha em tarefas).

### Risco 4: Escopo Fora de Controle
- **Impacto**: Alto (delays, orçamento).
- **Probabilidade**: Média.
- **Mitigação**:
  - Escopo rígido para MVP (nada de feature creep).
  - Jogo semanal com leads.
  - MoSCoW prioritization (Must/Should/Could/Won't).

### Risco 5: Retenção de Jogadores (quando publicado)
- **Impacto**: Médio (afeta monetização).
- **Probabilidade**: Alta (multiplayer é exigente).
- **Mitigação**:
  - Planejar seasonal content desde o início.
  - Implementar ladder/progression desde MVP.
  - Community management ativo.

---

## 8. Decisões Pendentes (Precisa de Stakeholder Input)

### 1. Engine Final
- **Opções**: Unity vs Unreal vs Godot.
- **Recomendação**: Unity (mais rápido para MVP).
- **Ação**: Decidir na **semana 0**.

### 2. Monetização
- **Opções**: F2P com cosmetics, Premium ($20–40), F2P agressivo.
- **Recomendação**: F2P com cosmetics (mais sustentável, boa para retention).
- **Ação**: Definir até **semana 4** (precisa de lógica de economia).

### 3. Multiplayer: Dedicated vs P2P
- **Opções**: Servidor dedicado (custo fixo), P2P (sem custo, menos estável).
- **Recomendação**: Servidor dedicado (melhor experiência, anti-cheat mais fácil).
- **Ação**: Arquitetar até **semana 2**.

### 4. Plataformas de Lançamento
- **Opções**: PC (Steam) first, depois consoles / Mobile.
- **Recomendação**: PC first, consoles em 2026.
- **Ação**: Decidir antes de **semana 4** (afeta otimização).

### 5. Publicação
- **Opções**: Self-published (Steam, Epic), Publisher parceiro.
- **Recomendação**: Self-published (mais controle, mas mais trabalho).
- **Ação**: Consultar com business team antes de **semana 8**.

---

## 9. Documentação Entregue (Até 16 de Novembro)

- [x] **GDD_Dustborn_v1.1.md** — Game Design Document completo.
- [x] **ARCHITECTURE_COLOSSUS.md** — Arquitetura técnica (Unity/Unreal/Godot).
- [x] **PROTOTYPE_COLOSSUS_TECHNICAL.md** — Guia prático de implementação.
- [x] **assets_by_sprint.csv** — Planilha de assets por sprint.
- [x] **Wireframes SVG** — HUD, painel do Colosso, inventário (versões wireframe + hi-fi).
- [x] **mockup_interactive.html** — Protótipo interativo com exportação para PNG.

**Próximos passos**: 
- Atualizar GDD conforme novas decisões são tomadas.
- Manter Prototype_Technical como "single source of truth" durante desenvolvimento.

---

## 10. Métricas de Sucesso (Post-Launch)

### Curto Prazo (Alpha/Beta)
- [ ] 50+ testers ativos no closed alpha.
- [ ] Average session > 30 minutos.
- [ ] Retenção D1/D7 > 40%.

### Médio Prazo (3 meses pós-launch)
- [ ] 10k+ concurrent players.
- [ ] Satisfação média > 4/5 (reviews).
- [ ] Revenue/MRR > $50k/mês.

### Longo Prazo (1 ano)
- [ ] 100k+ MAU (monthly active users).
- [ ] Comunidade ativa (Discord 50k+ members).
- [ ] Roadmap de conteúdo implementado (mínimo 2 zonas novas).

---

## 11. Próximos Passos Imediatos (Semana 0)

1. **Aprovação de Escopo** — Stakeholders confirmam MVP.
2. **Decisão de Engine** — Unity, Unreal ou Godot.
3. **Setup de Infraestrutura** — GitHub, CI/CD, comunicação (Discord/Slack).
4. **Kick-off com Equipe** — Sprint Planning da Semana 1.
5. **Configurar Ferramentas** — Jira, Asana ou Trello para task tracking.

---

## 12. Contatos & Escalation

| Função | Responsável | Contato |
|--------|------------|---------|
| Project Lead | TBD | email@dustborn.com |
| Lead Técnico | TBD | tech@dustborn.com |
| Design Lead | TBD | design@dustborn.com |
| Publisher/Stakeholder | TBD | stakeholder@dustborn.com |

---

## Conclusão

Dustborn é um projeto **viável e ambicioso** com escopo bem-definido. O MVP de 12 semanas fornece uma base sólida para um jogo multiplayer cooperativo único. Com a equipe certa e execução disciplinada, esperamos uma build jogável no Q1 2026.

**Status de Prontidão**: ✅ **PRONTO PARA KICKOFF**

---

**Versão**: 1.0  
**Data**: 16 de Novembro de 2025  
**Próxima Revisão**: Semana 4 (após Sprint 1 + 2)
