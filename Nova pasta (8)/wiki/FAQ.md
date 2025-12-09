<!-- Conteúdo completo extraído de FAQ_DEVELOPMENT.md -->
# FAQ & Propostas de Design — Dustborn

Documento com perguntas críticas, respostas propostas e espaço para decisões da equipe.

---

## Seção 1: Mecânicas Críticas (Prioridade Alta)

### 1.1 Desbloqueio de Zonas — Critérios Específicos

**Pergunta**: Como cada zona se abre? Quais são os requisitos exatos?

**Proposta**:

| Zona | Desbloqueio | Critério Específico |
|------|-----------|-------------------|
| Deserto Inicial | Início do jogo | — |
| Cânions | Completar "Fuga do Deserto" | Derrotar Reaver Leader; atingir Motor 80% integridade |
| Ferrovias | Completar "Rota de Cânions" | Coletar 5x Peça de Metal; Energy lvl 3 |
| Cidade Submersa | Completar "Pontos de Patrulha" | Derrotar 3x Mechatron; Food supply 100% |
| Radioativa | Completar "Câmara Selada" | Encontrar equipamento anti-rad; Oxygen lvl 2 |
| Muralha | Completar zona anterior + encontrar mapa | Ter Motor lvl 5; Combustível máx |

**Decisão Necessária**: ✋ Esses critérios fazem sentido? Ajustar?

---

### 1.2 Sistema de Roles — Seleção, Permissões e Dinâmica

**Pergunta**: Como os 4 roles (Piloto, Engenheiro, Atirador, Scavenger) são atribuídos? Há conflito se 2 querem o mesmo role?

**Proposta**:

#### Dinâmica de Atribuição

- **Atribuição**: Livre ao spawnar (cada jogador escolhe role na tela de seleção).
- **Conflito**: Se todos escolhem Piloto, o sistema prioriza quem conectou primeiro.
- **Mudança**: Permitir trocar role a cada 5 minutos (ou ao morrer/respawnar).
- **Ideal**: Recompensa XP extra se completar tarefa do role (ex.: Engenheiro que repara = +50 XP).

#### Permissões por Role

| Área/Sistema | Piloto | Engenheiro | Atirador | Scavenger |
|-------------|--------|-----------|---------|-----------|
| Sala de Motores | Ligar motor ✅ | Reparar ✅ | — | — |
| Sala de Comando | Navegar, waypoints ✅ | — | Indicadores de inimigos ✅ | — |
| Oficina | — | Craft, upgrade ✅ | — | Desmontar itens ✅ |
| Arsenal | Munição ✅ | — | Organizar armas ✅ | — |
| Exploração | — | — | Vanguarda ✅ | Scout (drones) ✅ |

#### Tarefas Cooperativas Obrigatórias

- **Ignição do Motor**: Requer Piloto + Engenheiro (em sincronismo com button presses).
- **Reparos Críticos**: Engenheiro sozinho pode, mas mais rápido se Atirador "protege" (vs inimigos).
- **Coleta de Recursos**: Scavenger é 30% mais rápido; outros podem fazer também.

**Decisão Necessária**: ✋ Permissões restritivas demais? Todos devem poder fazer tudo?

---

### 1.3 Perda do Colosso — É Possível? Consequência?

**Pergunta**: Se o Colosso tomar dano demais e for "destruído", o que acontece? Game Over ou recuperável?

**Proposta A (Recomendado)**: Colosso NÃO pode ser destruído permanentemente
- **Lógica**: Motor é essencial para progressão; destruição = frustração.
- **Mecanismo**: Quando integridade total < 10%, Colosso entra modo "Limp" (movimento -50%, sem reparos por 2 min).
- **Recuperação**: Automática após período ou reparos completos.
- **Risco**: Iminência de falha cria tensão sem Game Over.

**Proposta B (Alternativa)**: Colosso pode ser "capturado" mas não destruído
- **Lógica**: Se Motor falha completamente, facção inimiga toma o Colosso.
- **Consequência**: Grupo é teleportado para ponto de seguro próximo; perdem o Colosso por 10 minutos.
- **Resgate**: Missão especial para recuperar Colosso (difícil, recompensa alta).
- **Risco**: Muito punitivo; retenção pode sofrer.

**Proposta C**: Game Over se Colosso é destruído
- **Lógica**: Modo hardcore, permadeath de grupo.
- **Aplicação**: Apenas em servidores permadeath; MVP usa Proposta A.

**Recomendação**: Começar com **Proposta A** (MVP). Pode-se adicionar Proposta B/C em futuros modos hardcore.

**Decisão Necessária**: ✋ Qual modelo preferem?

---

### 1.4 Persistência — Onde São Salvos os Dados?

**Pergunta**: Dados do jogador e do grupo são salvos? Localmente ou servidor?

**Proposta**:

#### Arquitetura de Save

- **Servidor**: Salva dados de progresso do **grupo** (posição Colosso, integridade cômodos, combustível, inventário compartilhado).
- **Cliente**: Salva apenas cache local (última posição, UI prefs).
- **Frequência**: Autosave a cada 5 minutos ou após evento importante (derrota de boss, entrada de zona).

#### Checkpoints

- **Por Zona**: Ao entrar zona nova, Colosso respawna naquele checkpoint se grupo falhar.
- **No Meio da Zona**: Acampamentos (destroços, áreas seguras) funcionam como checkpoints secundários.
- **Respawn do Jogador**: Se morre, respawna no Colosso (se motor está rodando) ou checkpoint mais próximo.

#### Dados Persistentes Globais

- **Progresso de Zona**: "Zona X já visitada?" (não reseta).
- **Reputação de Facção**: Salva globalmente (não reseta por sessão).
- **Blueprints Descobertos**: Uma vez encontrado, fica na biblioteca (global).
- **Morte de Boss**: Boss não respawna na mesma sessão (mas respawna em nova sessão).

**Decisão Necessária**: ✋ Frecuência de autosave é ok? Há perda aceitável de ~5 min de progresso?

---

### 1.5 PvP vs PvE — Há Friendly Fire? Roubo Entre Companheiros?

**Pergunta**: Podem jogadores se ferir? Roubar do inventário um do outro?

**Proposta A (Recomendado para MVP)**: PvE Puro (Sem FF, Sem Roubo)
- **Friendly Fire**: DESATIVADO. Armas não machucam aliados.
- **Roubo**: Impossível. Inventário é pessoal + compartilhado (módulos do Colosso).
- **Sabotagem**: Não há (ex.: não pode desligar motor do outro).
- **Vantagem**: Foco em cooperação, sem toxicidade.
- **Desvantagem**: Menos emergência/risco humano.

**Proposta B (Optional para v1.1)**: PvP Consensual em Servidor Separado
- **Servidor PvP**: Friendly Fire ON, roubo possível, permadeath.
- **Servidor PvE**: FF OFF (padrão MVP).
- **Economia**: PvP incentiva grinding mais agressivo.
- **Moderação**: Mais risco de griefing; requer sistemas anti-exploit.

**Recomendação**: MVP começa com **Proposta A**. Adicionar servidor PvP em v1.1 se houver demanda.

**Decisão Necessária**: ✋ Começar com PvE puro (mais seguro)?

---

## Seção 2: Lore & Narrativa (Prioridade Média)

### 2.1 Lore Detalhado — Timeline da Guerra

**Pergunta**: O que causou o colapso? Qual é a timeline do mundo?

**Proposta de Timeline**:

```
Ano 2040 (Passado)
├─ Início da degradação da camada de ozônio por emissões.
├─ Primeiras tempestades solares extremas.
└─ Nações entram em conflito por recursos.

Ano 2080 (Colapso)
├─ Camada de ozônio desaparece completamente.
├─ Guerra nuclear/biológica entre potências (EUA, China, Rússia?).
├─ Cidades-muralha são construídas em semanas.
└─ 90% da população morre (radiação, fome, caos).

Ano 2100 (Era Atual — Dustborn se passa aqui)
├─ Mundo é uma ruína: deserto, tempestades solares, zona de guerra fria.
├─ Cidades-muralha isoladas (teoria conspiração: têm cura/tecnologia).
├─ Facções nômades emergem do caos.
├─ Muralha principal é guarnição militar em ruína.
└─ Kael nasce em ~2095 (5 anos antes do jogo começar).
```

**Pergunta Secundária**: Por que a muralha divide o mundo? O que há do outro lado?

**Proposta**: 
- **Lado Externo** (onde jogo começa): Deserto, ruínas, facções nômades.
- **Lado Interno** (final do jogo): Cidade-muralha tecnológica mas **distópica** — opressiva, controlada por IA ou ditador.
- **Objetivo Final**: Kael descobre que interior é pior; final é ambíguo ("conquistou liberdade ou entrou em prisão?").

**Decisão Necessária**: ✋ Este contexto de lore funciona? Quer algo mais? Menos?

---

### 2.2 Narrativa de Kael — Estrutura de Atos

**Pergunta**: Como é a campanha de single-player do Kael? Qual é a estrutura?

**Proposta de Atos**:

#### Ato 1: "A Fuga" (Zonas 1-2)
- Kael parte do Posto de Monitoramento (início seguro).
- Velho que o criou morre (cutscene comovente).
- Kael descobre mapa para muralha em diário do velho.
- **Objetivo**: Sair do Deserto Inicial e entrar nos Cânions.
- **Boss**: Reaver Leader (primeiro grande obstáculo).
- **Chave Narrativa**: "Viver nas sombras é mais seguro que na poeira."

#### Ato 2: "As Rotas" (Zonas 3-4)
- Kael encontra facção (Echo Nomads ou Iron Wraiths).
- Descobre que muralha está **fortemente guarnecida** — travessia direta é suicídio.
- Busca aliados ou rota alternativa.
- **Objetivo**: Chegar à Muralha (zona 6).
- **Boss**: Mechatron Sentinel (máquina de guerra da época de conflito).
- **Chave Narrativa**: "Sozinho, nunca chegará. Mas confiar é mortal."

#### Ato 3: "A Muralha" (Zona 6)
- Kael chega à muralha; consegue contato com lado interno.
- Descobre verdade: lado interno é **não é paraíso, é inferno controlado**.
- Dois finais possíveis:
	- **Final A (Esperança)**: Kael entra na muralha, encontra comunidade de resistência lá dentro. Esperança.
	- **Final B (Realismo)**: Kael percebe engano, recusa entrar. Fica no deserto como novo "velho solitário". Bittersweet.
- **Chave Narrativa**: "A liberdade verdadeira é estar vivo."

**Pergunta Secundária**: Há personagens secundários importantes?

**Proposta**:
- **Velho (criador de Kael)**: Mentor moral, morre cedo.
- **Echo Scout (facção)**: Antagonista amigável; testa lealdade de Kael.
- **Mechatron IA**: Boss final; inteligência artificial antiga que guarda muralha.

**Decisão Necessária**: ✋ Estrutura de 3 atos funciona? Quer mais nuance nos finais?

---

### 2.3 Facções — Detalhes de Reputação

**Pergunta**: Como o sistema de reputação com facções funciona?

**Proposta**:

#### Escala de Reputação

```
-100 a -50: INIMIGO MORTAL
	└─ Facção envia squad para matar grupo.
	└─ Vendor não vende; ataca se aproximar.
	└─ Contratos inacessíveis.

-49 a 0: HOSTIL
	└─ Facção não coopera; pode emboscar.
	└─ Preços +50% em vendas.

1 a 49: NEUTRO
	└─ Sem bonus/penalty.
	└─ Contratos disponíveis (baixa recompensa).

50 a 99: AMIGÁVEL
	└─ Vendor oferece desconto 15%.
	└─ Contratos recompensa +25%.
	└─ Acesso a upgrades exclusivos lvl 1.

100+: ALIADO
	└─ Desconto 30%, contratos +50% recompensa.
	└─ Acesso a upgrades exclusivos lvl 2-3.
	└─ Pode recrutar NPC como guia/escolta.
```

#### Ganho/Perda de Reputação

| Ação | Facção | Mudança |
|------|--------|--------|
| Completar contrato | +30 |
| Derrotar inimigo da facção | +10 |
| Roubar/destruir suprimentos | -20 |
| Aceitar contrato e falhar | -15 |
| Aliado de facção rival | -25 (automático) |

#### Facção Rival Automática

- Ajudar **The Reavers** → **Echo Nomads** fica -25.
- Ajudar **The Scorch** → **Iron Wraiths** fica -25.
- **Guardians of the Gate** são neutros com todos até final.

**Decisão Necessária**: ✋ Sistema de reputação faz sentido? Quer relações mais complexas (múltiplos níveis)?

---

## Seção 3: Sistemas de Gameplay (Prioridade Média)

### 3.1 Armas — Lista e Degradação

**Pergunta**: Quais armas existem? Como degradam?

**Proposta de Lista Inicial**:

| Arma | Dano | Alcance | Cadência | Munição | Raro? |
|------|------|--------|---------|--------|-------|
| Pistola (9mm) | 10 | 30m | Média | 9mm (comum) | — |
| Rifle Caça | 25 | 80m | Baixa | .308 (comum) | — |
| SMG | 12 | 25m | Alta | 9mm | — |
| Shotgun | 35 | 15m | Baixa | 12g (comum) | — |
| Rifle de Assalto | 18 | 60m | Alta | 5.56 (raro) | ✅ |
| Sniper | 40 | 150m | Muito Baixa | .338 (raro) | ✅ |
| Arco/Besta | 15 | 50m | Média | Flecha (craftável) | — |

#### Sistema de Degradação

- **Taxa**: Cada tiro reduz condição -1% (durabilidade).
- **Limite**: Em 50% de condição, arma fica "imprecisa" (-20% acurácia).
- **Quebrada**: Em 0%, arma não funciona.
- **Reparo**: Oficina pode restaurar com "Repair Kits" e componentes.
- **Modificação**: Slots para silenciador, mira, estoque (customização).

**Decisão Necessária**: ✋ Lista de armas é balanceada? Faltam/sobram tipos?

---

### 3.2 Veículos Secundários — Stats Completos

**Pergunta**: Qual é a performance de cada veículo?

**Proposta**:

| Veículo | Velocidade | Armadura | Capacidade | Combustível | Passageiros | Raro? |
|---------|-----------|----------|-----------|-------------|-------------|-------|
| Motorbike | 90 km/h | Nenhuma | 50kg | 20L | 1 | — |
| Buggy Leve | 70 km/h | 30% | 200kg | 40L | 2 | — |
| Van Blindada | 50 km/h | 60% | 400kg | 60L | 4 | ✅ |
| Drone Scout | 60 km/h | Nenhuma | 5kg | 2h batt | 0 (autonomia) | — |

#### Mecânica de Uso

- **Reparos**: Cada veículo tem HP; pode danificar em combate.
- **Combustível**: Consome de reserva coletiva (mesmo do Colosso).
- **Retorno**: Devem retornar ao Colosso para "dock" (carregar batt, reabastecimento).
- **Perda**: Não se destruído longe, não é perdido (loot drops, precisa craftar novo apenas Drone Scout).

**Decisão Necessária**: ✋ Stats fazem sentido? Qual é o trade-off entre velocidade/armadura?

---

### 3.3 Eventos Dinâmicos — Lista e Probabilidade

**Pergunta**: Quais eventos aleatórios podem acontecer?

**Proposta**:

| Evento | Probabilidade | Efeito | Como Lidar |
|--------|--------------|--------|-----------|
| Emboscada Reaver | 15%/hora exploração | 3-5 inimigos | Lutar ou fugir |
| Descoberta: Suprimentos | 10%/hora | +20 recursos aleatórios | Coletar |
| Tempestade Radiativa | 5%/hora | -10% armadura, visão reduzida | Entrar em bunker ou esperar |
| Traidor de Facção | 3%/contrato | NPC trai, ajuda inimigos | Defesa rápida |
| Máquina Quebrada (Scrap) | 8%/zona | Drone/Mechatron disfuncional | Reparar ou destruir por peças |
| Resgate de NPC | 7%/zona | NPC preso precisa ajuda | Salvá-lo = +reputação facção |
| Colapso Estrutural | 5%/cidade submersa | Prédio cai, bloqueia rota | Desviar ou cavar saída |

#### Probabilidade por Zona

- **Deserto**: Emboscadas mais comuns.
- **Cânions**: Colapsos mais comuns.
- **Radioativa**: Tempestades mais comuns.

**Decisão Necessária**: ✋ Eventos criam a narrativa emergente certa? Faltam tipos?

---

## Seção 4: Sistemas Secundários (Prioridade Baixa)

### 4.1 Customização & Cosmetics

**Pergunta**: Há skins, customização visual? Monetização?

**Proposta**:

#### Cosmetics Grátis (In-Game)

- **Pintura do Colosso**: Cores (camo, brilhante, etc) desbloqueáveis por progresso.
- **Customização de Personagem**: Roupa, capacete, óculos (encontrados ou craftáveis).
- **Nomes/Tags**: Jogador pode nomear Colosso (ex.: "Titã Vermelho").

#### Cosmetics Premium (Cosmetic Shop, Opcional)

- **Battle Pass**: Skins sazonais, emotes, trails.
- **Bundles**: "The Reaver Pack" (skin + weapon skin + adesivos).
- **Preço**: $4.99–9.99 por bundle.
- **Modelo**: Free-to-Play com cosmetics, sem Pay-to-Win.

**Decisão Necessária**: ✋ Quer cosmetics desde MVP ou adicionar depois?

---

### 4.2 Sistema de Clãs / Guildas (Pós-MVP)

**Pergunta**: Há suporte para equipes permanentes?

**Proposta (v1.2+)**:

- **Clã**: Até 50 membros, tag customizável, treasury (recursos compartilhados).
- **Perks**: Bônus de reputação, acesso a "Clan Base" (servidor privado).
- **Hierarquia**: Líder, Oficiais, Membros.
- **Guerras de Clã**: Clãs podem competir por zonas de recurso.

---

## Seção 5: Decisões Finais para Kickoff

### Checklist de Aprovação

Antes de iniciar Sprint 1, stakeholders precisam decidir:

- [ ] **Zona 1 Desbloqueio** — Critérios aprovados? (seção 1.1)
- [ ] **Modelo de Roles** — Permissões restritivas ou livres? (seção 1.2)
- [ ] **Destruição do Colosso** — Proposta A (Limp Mode)? (seção 1.3)
- [ ] **Persistência** — Autosave a cada 5 min? (seção 1.4)
- [ ] **PvP** — Puro PvE (MVP)? (seção 1.5)
- [ ] **Lore Timeline** — Proposta de 60 anos de história? (seção 2.1)
- [ ] **Atos de Kael** — Estrutura 3-atos? (seção 2.2)
- [ ] **Reputação de Facção** — Escala -100 a +100? (seção 2.3)
- [ ] **Armas MVP** — 7 tipos listados? (seção 3.1)
- [ ] **Veículos Secundários** — Stats aprovados? (seção 3.2)
- [ ] **Eventos Dinâmicos** — Lista de 7 eventos? (seção 3.3)
- [ ] **Cosmetics** — MVP grátis, premium pós-launch? (seção 4.1)
- [ ] **Clãs** — Apenas em v1.2+? (seção 4.2)

---

## Seção 6: Template de Respostas

Para cada decisão acima, favor preencher:

```
[Número da Seção]
Decision: _______________
Rationale: _______________
Date: _______________
Approved By: _______________
```

Exemplo:
```
1.3 (Destruição do Colosso)
Decision: Proposta A (Limp Mode)
Rationale: Cria tensão sem frustração; melhor retenção.
Date: 2025-11-16
Approved By: Game Director
```

---

**Versão**: 1.0  
**Data**: 16 de Novembro de 2025  
**Status**: Aguardando Decisões de Stakeholders  
**Próxima Revisão**: Semana 1 (após aprovações)

Esta página espelha `FAQ_DEVELOPMENT.md`. Aqui estão os pontos que precisam de aprovação dos stakeholders:

1. Permissões/roles: definição de pilot, engineer, gunner — aprovadas/pendentes.
2. Modelo de persistência: servidor‑lado persistência em checkpoints — escolha pendente.
3. PvP: ativado entre jogadores em arenas específicas? — decisão pendente.
4. Destruição do Colossus: parcial vs total — decisão pendente.
5. Economia: como contratos pagam e quais recursos são persistidos — pendente.
6. Escopo de assets para MVP — priorizar placeholders vs arte final.
7. Política de salvamento automático (intervalos/condições) — pendente.
8. Modo multiplayer: sessões instanciadas vs mundo persistent — pendente.
9. Licenciamento de ferramentas/terceiros (middleware de rede) — verificação necessária.
10. Tipos de inimigos e balanceamento inicial — pendente.
11. Regras de matchmaking para equipes — pendente.
12. Cross‑play e autenticação — pendente.
13. Métricas de telemetria e logs a coletar para análise — pendente.

Marque as decisões aprovadas e registre comentários para cada item.
