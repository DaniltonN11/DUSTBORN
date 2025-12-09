<!-- Conteúdo completo extraído de ARCHITECTURE_COLOSSUS.md -->
# Arquitetura Técnica — O Colosso

Documento técnico descrevendo a arquitetura, estrutura de componentes e sincronização multiplayer do Colosso para as 3 principais engines: **Unity**, **Unreal Engine** e **Godot**.

---

## 1. Visão Geral da Arquitetura

O Colosso é um veículo móvel colossal com múltiplos cômodos interconectados. Requisitos principais:

- Estrutura **modular** (cômodos independentes que podem ser danificados/reparados).
- Movimento **contínuo** controlado por pilotos (sem frenagem automática).
- Sincronização multiplayer **autoritária no servidor** para estado crítico.
- Tarefas **cooperativas e simultâneas** (ignição em etapas, reparos paralelos).
- Física de **colisão com ambiente** e dano aos cômodos.

### Componentes Principais

1. **ColossusController** — controlador central de movimento e estado.
2. **RoomModule** — prefab base para cômodos (motor, oficina, etc).
3. **EngineSystem** — lógica de motor, etapas de ativação, consumo de combustível.
4. **NetworkManager** — sincronização de estado multiplayer.
5. **InventoryContainer** — gerenciamento de itens por módulo.
6. **DamageSystem** — cálculo de integridade, estados danificados.

---

## 2. Estrutura de Cômodos (Room Modules)

Cada cômodo é um prefab/ator com componentes/scripts compartilhados:

### Estrutura Base

Colossus (Root Transform)
├── RoomModule_Motor (Sala de Motores)
│   ├── EngineCore (component/script)
│   ├── Collider (trigger)
│   ├── Inventory (slots para peças do motor)
│   └── InteractionPoints (painéis, alavancas)
├── RoomModule_Command (Sala de Comando)
│   ├── ConsoleUI (interativa)
│   ├── Collider
│   └── InteractionPoints
├── RoomModule_Workshop (Oficina)
│   ├── CraftingStation (component/script)
│   ├── Inventory
│   └── Tools
├── RoomModule_Dormitory
├── RoomModule_Arsenal
├── RoomModule_Kitchen
└── RoomModule_Hull (blindagem externa, armações)

### Script Base (Pseudocódigo Abstrato)

```csharp
// RoomModule.cs (Unity) / RoomModule.h (Unreal)
public class RoomModule : MonoBehaviour / AActor
{
  public string roomName = "Motor";
  public float maxIntegrity = 100f;
  public float currentIntegrity = 100f;
    
  public RoomState roomState = RoomState.Functional; // Functional, Damaged, Offline
  public InventoryContainer inventory;
    
  public void TakeDamage(float amount) {
    currentIntegrity -= amount;
    if (currentIntegrity <= 0) roomState = RoomState.Offline;
    else if (currentIntegrity < 50) roomState = RoomState.Damaged;
    UpdateVisuals();
  }
    
  public void Repair(float amount) {
    currentIntegrity = Mathf.Min(currentIntegrity + amount, maxIntegrity);
    if (currentIntegrity >= 50) roomState = RoomState.Functional;
  }
    
  private void UpdateVisuals() {
    // Mudar material/shader para estado danificado, partículas de fumaça, etc.
  }
}
```

---

## 3. Sistema de Motor (Engine System)

Motor requer processo de ativação em etapas. Cada etapa é uma tarefa cooperativa.

### Estados do Motor

1. **Offline** — desligado, requer ativação.
2. **Starting (Step 1)** — inicialização de núcleo (30s).
3. **Starting (Step 2)** — aceleração de cilindros (40s).
4. **Starting (Step 3)** — estabilização (20s).
5. **Running** — operacional.
6. **Stalling** — falha (timeout ou dano crítico).

### Script do Motor (Pseudocódigo)

```csharp
public class EngineSystem : MonoBehaviour / AActor
{
  public enum EngineState { Offline, Starting_Step1, Starting_Step2, Starting_Step3, Running, Stalling }
  public EngineState currentState = EngineState.Offline;
    
  public float fuelConsumption = 5f; // litros/min enquanto rodando
  public float currentFuel = 100f;
  public float maxFuel = 200f;
    
  public float energy = 100f; // energia do sistema (alimenta motor)
  public float maxEnergy = 200f;
    
  private float stepTimer = 0f;
  private float stepDuration = 30f; // segundos
    
  public void StartEngineSequence() {
    if (currentState != EngineState.Offline) return;
    currentState = EngineState.Starting_Step1;
    stepTimer = 0f;
    stepDuration = 30f;
    BroadcastToPlayers("Engine startup initiated — Step 1");
  }
    
  public void Update() {
    if (currentState == EngineState.Offline || currentState == EngineState.Running) return;
        
    stepTimer += Time.deltaTime;
    if (stepTimer >= stepDuration) {
      AdvanceEngineStep();
    }
        
    if (currentState == EngineState.Running) {
      ConsumeFuel(fuelConsumption * Time.deltaTime / 60f);
      ConsumeEnergy(10f * Time.deltaTime / 60f); // energia auxiliar
    }
  }
    
  private void AdvanceEngineStep() {
    switch (currentState) {
      case EngineState.Starting_Step1:
        currentState = EngineState.Starting_Step2;
        stepDuration = 40f;
        break;
      case EngineState.Starting_Step2:
        currentState = EngineState.Starting_Step3;
        stepDuration = 20f;
        break;
      case EngineState.Starting_Step3:
        currentState = EngineState.Running;
        BroadcastToPlayers("Engine running");
        break;
    }
  }
    
  private void ConsumeFuel(float amount) {
    currentFuel -= amount;
    if (currentFuel <= 0) Stall();
  }
    
  private void Stall() {
    currentState = EngineState.Stalling;
    BroadcastToPlayers("Engine stalled!");
  }
}
```

---

## 4. Controlador de Movimento (ColossusController)

Gerencia translação, rotação e física do Colosso como um todo. O movimento **não freia automaticamente**; pilotos controlam aceleração/velocidade.

### Script de Movimento

```csharp
public class ColossusController : MonoBehaviour / APawn
{
  public float maxSpeed = 30f; // km/h
  public float acceleration = 5f;
  public float rotationSpeed = 2f;
    
  private Vector3 currentVelocity = Vector3.zero;
  private Rigidbody colossusRigidbody;
    
  public void ReceivePilotInput(float forwardInput, float turnInput) {
    // forwardInput: -1 (marcha ré) a 1 (frente)
    // turnInput: -1 (esquerda) a 1 (direita)
        
    float targetSpeed = forwardInput * maxSpeed;
    currentVelocity.z = Mathf.Lerp(currentVelocity.z, targetSpeed, acceleration * Time.deltaTime);
        
    float yaw = turnInput * rotationSpeed * Time.deltaTime;
    transform.Rotate(0, yaw, 0);
        
    transform.Translate(currentVelocity * Time.deltaTime, Space.Self);
  }
    
  public void Update() {
    // Aplicar atrito natural (desaceleração suave)
    if (Mathf.Abs(currentVelocity.z) > 0.1f) {
      currentVelocity.z *= 0.98f; // desaceleração gradual
    }
  }
}
```

---

## 5. Sincronização Multiplayer

### Modelo: Servidor Autoritário

- **Servidor** mantém estado canônico do Colossus (posição, rotação, estado do motor, integridade dos cômodos).
- **Clientes** enviam input de piloto e recebem atualizações de estado.
- **Checksum** de integridade é transmitido periodicamente para sincronização.

### Frequência de Sincronização

- Posição/rotação do Colossus: **20 ticks/seg** (50ms).
- Estado do motor: **1 tick/seg** (1s).
- Integridade dos cômodos: **2 ticks/seg** (500ms) ou event-driven.

### Pseudocódigo de Rede (Unity Netcode/Unreal Replication)

```csharp
// NetworkColossusState.cs
[NetSerialize]
public struct ColossusNetState
{
  public Vector3 position;
  public Quaternion rotation;
  public float engineFuel;
  public EngineSystem.EngineState engineState;
  public Dictionary<string, float> roomIntegrity; // roomName -> integridade
}

public class NetworkColossusManager : NetworkBehaviour
{
  private ColossusController controller;
  private EngineSystem engine;
  private Dictionary<string, RoomModule> rooms;
    
  [ServerRpc]
  public void ReceivePilotInputServerRpc(ulong playerId, float forward, float turn) {
    if (!IsServer) return;
    controller.ReceivePilotInput(forward, turn);
  }
    
  [ObserverRpc]
  private void BroadcastColossusState(ColossusNetState state) {
    // Todos os clientes recebem este estado
    controller.SetNetworkState(state);
  }
    
  private void Update() {
    if (!IsServer) return;
        
    // Capturar estado atual e enviar aos clientes
    var state = new ColossusNetState {
      position = transform.position,
      rotation = transform.rotation,
      engineFuel = engine.currentFuel,
      engineState = engine.currentState,
      roomIntegrity = GetAllRoomIntegrity()
    };
        
    BroadcastColossusState(state);
  }
    
  private Dictionary<string, float> GetAllRoomIntegrity() {
    var dict = new Dictionary<string, float>();
    foreach (var room in rooms.Values) {
      dict[room.roomName] = room.currentIntegrity;
    }
    return dict;
  }
}
```

---

## 6. Específico por Engine

### Unity

- **Physics**: Rigidbody com Colliders (Box/Capsule para cômodos, BoxCollider grande para hull).
- **Rede**: Netcode for GameObjects ou Fusion (PhotonPUN2 alternativa).
- **Prefabs**: RoomModule como prefab base, instanciado para cada cômodo.
- **Serialização**: ScriptableObject para configurações de cômodos.

Exemplo de estrutura de prefab:
```
RoomModule (Prefab)
├── RoomModule.cs (componente)
├── BoxCollider (ou CapsuleCollider)
├── Rigidbody (kinematic para cômodos, ou sem física local)
├── InventoryContainer (componente)
├── MeshRenderer (visual do cômodo)
└── ParticleSystem (efeitos de dano)
```

### Unreal Engine

- **Physics**: PhysicsBody com Collision Channels customizados.
- **Rede**: Replication Framework (RPCs e replicated properties).
- **Actors**: RoomModule como AActor (ou Component anexado a um Pawn/Character).
- **Structs**: FColossusNetState para sincronização.

Exemplo de código Unreal (C++):
```cpp
UPROPERTY(Replicated)
float CurrentIntegrity;

UPROPERTY(Replicated)
EEngineState CurrentEngineState;

virtual void GetLifetimeReplicatedProps(TArray<FLifetimeProperty>& OutLifetimeProps) const override;

UFUNCTION(Server, Reliable, WithValidation)
void ServerReceivePilotInput(float Forward, float Turn);

UFUNCTION(NetMulticast, Reliable)
void MulticastUpdateColossusState(const FColossusNetState& NewState);
```

### Godot

- **Physics**: RigidBody3D ou CharacterBody3D (movimento customizado).
- **Rede**: MultiplayerSynchronizer e RPC calls.
- **Scenes**: RoomModule como subscena com script base.
- **Signals**: Usar signals para eventos de dano/reparo.

Exemplo de código Godot (GDScript):
```gdscript
extends Node3D
class_name ColossusController

@export var max_speed := 30.0
@export var acceleration := 5.0

var current_velocity := Vector3.ZERO

func _receive_pilot_input(forward: float, turn: float) -> void:
  var target_speed = forward * max_speed
  current_velocity.z = lerp(current_velocity.z, target_speed, acceleration * get_physics_process_delta_time())
  rotate_y(turn * 0.02)
  position += current_velocity * get_physics_process_delta_time()

@rpc("authority")
func sync_colossus_state(new_state: Dictionary) -> void:
  # Sincronizar estado de todos os clientes
  pass
```

---

## 7. Fluxo de Ativação do Motor (Cooperativo)

1. **Piloto** inicia sequência (aperta botão no console).
2. **Servidor** muda estado para `Starting_Step1`.
3. **Todos os clientes** veem contador de 30s na tela.
4. Após 30s, motor avança para `Step2` automaticamente.
5. **Engenheiro** pode intervir em case de falha (reparar componente crítico).
6. Após 90s total, motor fica `Running`.

Diagrama:
```
[Offline] --(StartEngineSequence)--> [Starting_Step1: 30s]
     |
     +--[Damage]--> [Stalling]
         
[Starting_Step1] --(timeout)--> [Starting_Step2: 40s]
         |
         +--[Damage/Sabotage]--> [Stalling]
                 
[Starting_Step2] --(timeout)--> [Starting_Step3: 20s]
         |
         +--[Damage]--> [Stalling]
                 
[Starting_Step3] --(timeout)--> [Running]

[Running] --(TakeDamage())--> [Damaged] (integridade < 50%)
    |
    +--(ConsumeFuel())--> [Stalling] (combustível = 0)
```

---

## 8. Áreas de Colisão e Dano

O Colosso possui múltiplas áreas de colisão para calcular dano por região:

- **Hull (Casco)**: grande collider envolvendo todo o Colosso.
- **RoomColliders**: colliders para cada cômodo (permite dano localizado).
- **Weak Points**: áreas de colisão menores com multiplicadores de dano (ex.: tomada de combustível = 2x).

```csharp
public class ColossusCollisionHandler : MonoBehaviour
{
  private Dictionary<Collider, string> colliderToRoom; // mapeia collider -> nome do cômodo
    
  private void OnCollisionEnter(Collision collision) {
    if (!IsServer) return;
        
    float impactForce = collision.relativeVelocity.magnitude;
    float damage = impactForce * 2f; // multiplicador
        
    string roomName = colliderToRoom[collision.collider];
    DamageRoom(roomName, damage);
  }
    
  private void DamageRoom(string roomName, float damage) {
    if (rooms.TryGetValue(roomName, out var room)) {
      room.TakeDamage(damage);
    }
  }
}
```

---

## 9. Tarefas Cooperativas e Sincronização

### Sistema de Tarefas (TaskSystem)

```csharp
public enum TaskType { IgnitionStep1, IgnitionStep2, RepairRoom, RestockSupplies }

[NetSerialize]
public struct CooperativeTask
{
  public TaskType taskType;
  public string targetRoom;
  public ulong assignedPlayerId; // jogador responsável
  public float progressPercent; // 0-100%
  public bool isComplete;
}

public class TaskManager : NetworkBehaviour
{
  public List<CooperativeTask> activeTasks = new();
    
  [ServerRpc]
  public void UpdateTaskProgressServerRpc(TaskType taskType, float delta) {
    var task = activeTasks.FirstOrDefault(t => t.taskType == taskType);
    if (task.Equals(default(CooperativeTask))) return;
        
    task.progressPercent += delta;
    if (task.progressPercent >= 100f) {
      task.isComplete = true;
      OnTaskComplete(task);
    }
  }
    
  private void OnTaskComplete(CooperativeTask task) {
    // Trigger ação (motor avança Step, cômodo reparado, etc)
  }
}
```

---

## 10. Checklist de Implementação (MVP)

- [ ] Criar prefab/classe base RoomModule.
- [ ] Implementar EngineSystem com 3 etapas.
- [ ] Implementar ColossusController com movimento não-automático.
- [ ] Configurar sincronização de servidor autoritário.
- [ ] Testar múltiplos jogadores controlando o motor.
- [ ] Adicionar collision detection e sistema de dano.
- [ ] UI mostrando estado do motor e integridade dos cômodos.
- [ ] Audio loops para motor e alertas de dano.

---

## 11. Referências e Recursos

- Unity Netcode: https://docs.unity.com/netcode/
- Unreal Networking: https://docs.unrealengine.com/en-US/Basics/Networking/
- Godot Networking: https://docs.godotengine.org/en/stable/tutorials/networking/index.html
