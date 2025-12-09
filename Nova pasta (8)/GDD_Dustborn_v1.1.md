# Dustborn — GDD v1.1

Versão consolidada do Game Design Document (GDD) baseada na Lousa Geral v1.0, incluindo propostas detalhadas para sistemas ainda em aberto: sistema de habilidades, morte/respawn, economia entre jogadores, contratos de facções, tipos de chefes e HUD.

## 1. Visão Geral

- Título: Dustborn
- Gênero: Survival / Ação / Mundo Aberto (coop multiplayer centrado em veículo móvel — "o Colosso")
- Escopo: campanha single-player com modo coop (4–6 jogadores ideal, mínimo 3).
- Tom: pós-apocalíptico, atmosférico, industrial, tenso.

## 2. Conceito Central

Dustborn é sobre atravessar lugares hostis usando um veículo colossal que funciona como base móvel e hub social. Jogadores precisam cooperar para mover, manter e proteger o Colosso, explorar zonas perigosas e cumprir missões que progridem até a muralha final.

## 3. Lore (resumo)

- Mundo: camada de ozônio perdida, sol mortal, tempestades solares e desertificação.
- Sociedades: facções tribais externas e cidades-muralha tecnologicamente isoladas.
- Protagonista do single-player: Kael — criado na poeira, objetivo de alcançar e atravessar a muralha.

## 4. Estrutura de Zonas

Lista e notas de desbloqueio:

1. Deserto Inicial — radiação moderada; tutorial de sobrevivência.
2. Cânions — sombras, emboscadas; mecânicas de furtividade.
3. Campos Ferroviários — máquinas antigas, puzzles com trilhos.
4. Cidade Submersa em Poeira — verticalidade e risco de desabamento.
5. Zonas Radioativas — dano ambiental contínuo; equipamento especial.
6. Chegada à Muralha — defesa pesada, combate de alto risco.

Desbloqueio: missões principais, recursos acumulados, upgrades do Colosso para atravessar terrenos.

## 5. Inimigos e Comportamentos

- Dust Reavers: saqueadores móveis, táticos.
- Carcinos: predadores, atacam em emboscada e em dia intenso.
- Mecatrons: robôs hostis da guerra antiga, podem patrulhar rotas.
- Aspidianos: mutações subterrâneas, ataques surpresa.
- Tempestade Viva: evento ambiental com IA de dano e comportamento.

Comportamentos-chave: emboscadas, ataques dirigidos ao Colosso (cômodos e motor), roubo de inventário (em áreas expostas), perseguição dinâmica.

## 6. Facções (resumo)

- The Reavers — saqueadores brutos.
- The Scorch — fanáticos solares.
- Iron Wraiths — mecanizados e frios.
- Echo Nomads — nômades, comercio e informação.
- Guardians of the Gate — defensores da muralha.

Cada facção controla rotas, recursos e contratos; reputação afeta acesso a upgrades.

## 7. O Colosso — Visão Arquitetural

Cômodos principais: Sala de Motores, Sala de Comando, Dormitórios, Cozinha/Água, Oficina/Crafting, Arsenal, Armações Externas.

Características:
- Movimento comandado por pilotos; tarefas simultâneas requeridas para ignição e manutenção.
- Jogadores podem andar no Colosso em movimento.
- Cômodos possuem estados: íntegro, danificado, offline.
- Recursos: combustível, energia, água, filtros.

## 8. Veículos Secundários

- Motos de areia, buggy leve, van blindada, drones de scouting.

Função: exploração rápida, busca de recursos, suporte tático.

## 9. Inventário e Sistema de Itens

- Inventário físico grid (inspiração: Escape From Tarkov). Peso/volume afeta mobilidade.
- Inventário coletivo do Colosso com módulos (Oficina, Arsenal, Provisões).
- Itens podem ser perdidos ou roubados; armazenamento seguro requer módulos de proteção.

## 10. Crafting

- Bancada física na Oficina do Colosso.
- Estações separadas: armas, armaduras, motor, consumíveis.
- Requer blueprints, componentes raros e energia.

## 11. Sistema Climático

- Tempestades de poeira, furacões secos, pancadas solares, noites congelantes.
- Efeitos: redução de visão, dano ao longo do tempo, risco de falha do motor, degradação de peças.

## 12. Loop Principal

1. Explorar e reunir recursos.
2. Reforçar e reparar o Colosso.
3. Gerenciar suprimentos (combustível, água, filtros, munição).
4. Avançar zona a zona até a muralha; derrotar defesas.

---

## 13. Propostas Detalhadas — Sistemas em Aberto

### 13.1 Sistema de Habilidades (proposta)

- Estrutura: 4 árvores de habilidades por papel (Piloto, Engenheiro, Atirador, Scavenger).
- Gasto: pontos de habilidade ganhos por XP (missões, reparos, combate, exploração).
- Formato: mistura de passivas e ativas; cooldowns e custo de recursos para habilidades ativas.

Exemplos de nós:
- Piloto: "Overdrive" (buff temporário de velocidade do Colosso), "Manejo Fino" (+controle em terrenos difíceis).
- Engenheiro: "Patch Rápido" (cura instantânea limitada de cômodo), "Circuito Otimizado" (reduz consumo de energia).
- Atirador: "Foco de Longo Alcance" (+precisão), "Tiro de Supressão" (mena de reações inimigas).
- Scavenger: "Olho de Caçador" (+chance de encontrar componentes raros), "Carga Leve" (redução de peso de certos itens).

Balanceamento: limitar a sobreposição com cooldowns, slots equipáveis e custo significativo em pontos para habilidades muito poderosas.

### 13.2 Morte e Respawn (proposta)

- Estados:
  - Incapacitado: ao tomar dano letal entra estado com timer; companheiros podem reviver usando um kit de emergência.
  - Morto: se não revivido, respawn no Colosso ou ponto seguro com penalidade.

- Penalidades:
  - Perda percentual de recursos (ex.: 10–30% dos itens carregados).
  - Itens valiosos fora do Colosso podem ficar disponíveis para saque (sistema de "drop" físico no mundo).

- PvP servers: seguro opcional (insurance) para recuperar itens por preço; perda maior em servidores hardcore.

### 13.3 Economia entre Jogadores

- Inventário compartilhado por módulos do Colosso (controle de permissões por cargo).
- Trocas diretas entre jogadores; leilões em hubs NPC; barter comum (peças, energia, água).
- Moeda/creditos limitada: contratos e NPCs podem pagar em credits ou em bens trocáveis.

Risco vs Recompensa:
- Levar loot para fora do Colosso aumenta valor, porém fica vulnerável.
- Armazenamento seguro reduz risco, mas requer investimentos em módulos de segurança.

### 13.4 Contratos de Facções

- Sistema de reputação com níveis; contratos aparecem por reputação e por disponibilidade dinâminca.
- Tipos de contrato: escolta, ataque, recuperação, sabotagem, contrabando.
- Recompensas: credits, blueprints, acesso a upgrades do Colosso exclusivos.

Consequências: contratos de uma facção podem afetar reputação com outras, abrindo/fechando opções de narrativa.

### 13.5 Chefes e Encontros de Zona

- Escala: minibosses (patrulhas únicas), bosses de zona (multi-fase), eventos ambientais (Tempestade Viva como "boss").

Exemplos:
- Reaver Leader: líder de gangue com táticas de emboscada e minions.
- Carcino Alpha: criatura grande com ataque de área e resistência ao sol.
- Mechatron Sentinel: robô com escudos e fases de sobrecarga.

Drops de chefes: partes raras para motor, chips de hacking e blueprints exclusivos.

### 13.6 HUD e Interface (especificação)

Elementos principais:
- Player HUD: vida, fome, sede, radiação, temperatura, stamina.
- Status do Colosso: energia, combustível, integridade (por setor), temperatura interna, alertas de clima.
- Mini‑map/Mapa: waypoints, zonas de perigo, marcações de contratos.
- Inventário: grid físico com peso/volume, slots especiais para componentes.
- Painel do Colosso (UI multi-usuário): lista de tarefas ativas (ignição, reparos), roles atribuídos, status por cômodo.

Alertas visuais e sonoros: tempestade, ataque ao Colosso, falha crítica no motor, falta de água.

Design de interação: arrastar/colar para gerenciamento de inventário; confirmação para saques permanentes.

## 14. Arquitetura Multiplayer (técnica — resumo)

- Modelo preferido: servidor dedicado (autoridade do servidor para estado crítico do Colosso). Host migration como fallback para sessões P2P.
- Sincronização: estado do Colosso e economia authoritative; posição/entrada de players com previsão cliente e correção por servidor.
- Segurança: checagens de integridade do inventário, anti‑exploit para trade e exploits de física.

## 15. MVP Recomendado

- Conteúdo mínimo jogável:
  - 1 zona inicial completa + 1 zona secundária pequena.
  - Colosso básico: motor (etapas de ativação), 3 cômodos funcionais, movimento simples.
  - Multiplayer mínimo 3 jogadores com roles Piloto, Engenheiro, Atirador.
  - Inventário grid, crafting básico, 2 tipos de inimigos e 1 miniboss.

## 16. Lista de Assets Prioritários

- Modelos: Colosso modular, 3 veículos leves, 4 inimigos principais, 3 NPC facções.
- FX/Áudio: tempestade de poeira, motor, alertas de painel.
- UI: HUD modular, inventário grid, painel do Colosso.

## 17. Milestones de Curto Prazo

1. Protótipo do Colosso (2 semanas) — movimento, cômodos, inventário básico.
2. Multiplayer básico (3 semanas) — sync de posições, roles e tarefas do motor.
3. Crafting e danos (3 semanas).
4. Zona inicial jogável e testes de coop (4 semanas).

## 18. Próximos Passos (técnicos e de design)

- Revisar e priorizar as árvores de habilidades e nós iniciais.
- Definir UI wireframes para o painel do Colosso e inventário.
- Prototipar módulo de motor (etapas de ignição) em engine escolhida.
- Iniciar lista detalhada de assets por sprint.

---

Arquivo criado a partir da Lousa v1.0 e das decisões/ideias consolidadas. Para continuar, posso:

- Gerar wireframes de HUD em PNG/SVG.
- Exportar uma versão reduzida para apresentação (PDF/slide).
- Começar a escrever a documentação técnica para o protótipo do Colosso.

Escolha o próximo passo ou peça ajustes específicos neste documento.
