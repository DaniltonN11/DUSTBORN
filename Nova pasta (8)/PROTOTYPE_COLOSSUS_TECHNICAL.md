# Protótipo Técnico do Colosso — Guia de Implementação

Documento prático para iniciar a implementação do Colosso. Inclui passos, código exemplo, testes e milestones de curto prazo.

---

## 1. Escolha de Engine e Stack Recomendado

### Opção A: Unity (Recomendado para prototipagem rápida)
- **Versão**: 2022 LTS ou 2023+
- **Rede**: Netcode for GameObjects + Transport
- **Física**: Built-in Physics (Rigidbody3D)
- **UI**: UI Toolkit (Canvas)
- **Tempo de setup**: ~2-3 dias

### Opção B: Unreal Engine
- **Versão**: UE 5.2+
- **Rede**: Replication Graph + Net Driver
- **Física**: PhysX/Chaos
- **UI**: Slate/UMG
- **Tempo de setup**: ~3-5 dias

### Opção C: Godot
- **Versão**: 4.1+
- **Rede**: MultiplayerSynchronizer
- **Física**: PhysicsBody3D + RigidBody3D
- **UI**: Control nodes (UI framework)
- **Tempo de setup**: ~2-3 dias

**Recomendação para MVP**: Unity (comunidade grande, documentação abundante, prototipagem rápida).

---

## 2. Estrutura de Pastas (Unity)

```
Assets/
├── Scenes/
│   ├── ColossusPrototype.unity
│   └── TestMultiplayer.unity
├── Scripts/
│   ├── Colossus/
│   │   ├── ColossusController.cs
│   │   ├── RoomModule.cs
│   │   ├── EngineSystem.cs
│   │   ├── ColossusInventory.cs
│   │   └── ColossusNetworkManager.cs
│   ├── Network/
│   │   ├── NetworkManager.cs
│   │   └── PlayerController.cs
│   └── UI/
│       ├── ColossusHUD.cs
│       └── RoomStatusUI.cs
├── Prefabs/
│   ├── Colossus/
│   │   ├── RoomModule.prefab
│   │   ├── EngineCore.prefab
│   │   └── InteractionPoint.prefab
│   └── UI/
│       └── ColossusPanel.prefab
├── Materials/
│   ├── RoomFunctional.mat
│   ├── RoomDamaged.mat
│   └── RoomOffline.mat
└── Audio/
    ├── EngineLoop.wav
    ├── EngineStart.wav
    └── Alarm_Damage.wav
```

---

## 3. Passo 1: Criar o Prefab Base (RoomModule)

### Script: `RoomModule.cs`

```csharp
using UnityEngine;
using Unity.Netcode;

public class RoomModule : NetworkBehaviour
{
    [SerializeField] public string roomName = "Motor";
    [SerializeField] public float maxIntegrity = 100f;
    
    public NetworkVariable<float> currentIntegrity = new NetworkVariable<float>(100f);
    public NetworkVariable<int> roomState = new NetworkVariable<int>(0); // 0=Functional, 1=Damaged, 2=Offline
    
    private MeshRenderer meshRenderer;
    private ParticleSystem damageParticles;
    private Material functionalMat, damagedMat, offlineMat;
    
    public override void OnNetworkSpawn()
    {
        meshRenderer = GetComponent<MeshRenderer>();
        damageParticles = GetComponentInChildren<ParticleSystem>();
        
        // Carregar materiais (assumindo que estão em Resources/Materials)
        functionalMat = Resources.Load<Material>("Materials/RoomFunctional");
        damagedMat = Resources.Load<Material>("Materials/RoomDamaged");
        offlineMat = Resources.Load<Material>("Materials/RoomOffline");
        
        currentIntegrity.OnValueChanged += UpdateVisuals;
    }
    
    [ServerRpc]
    public void TakeDamageServerRpc(float amount)
    {
        if (!IsServer) return;
        
        currentIntegrity.Value -= amount;
        
        if (currentIntegrity.Value <= 0)
        {
            roomState.Value = 2; // Offline
            currentIntegrity.Value = 0;
        }
        else if (currentIntegrity.Value < 50)
        {
            roomState.Value = 1; // Damaged
        }
        else
        {
            roomState.Value = 0; // Functional
        }
        
        Debug.Log($"[{roomName}] Integridade: {currentIntegrity.Value}%, Estado: {roomState.Value}");
    }
    
    [ServerRpc]
    public void RepairServerRpc(float amount)
    {
        if (!IsServer) return;
        
        currentIntegrity.Value = Mathf.Min(currentIntegrity.Value + amount, maxIntegrity);
        
        if (currentIntegrity.Value >= 50)
        {
            roomState.Value = 0; // Functional
        }
    }
    
    private void UpdateVisuals(float oldValue, float newValue)
    {
        Material newMat = roomState.Value switch
        {
            0 => functionalMat,
            1 => damagedMat,
            2 => offlineMat,
            _ => functionalMat
        };
        
        meshRenderer.material = newMat;
        
        if (roomState.Value == 1 || roomState.Value == 2)
        {
            if (damageParticles != null && !damageParticles.isPlaying)
                damageParticles.Play();
        }
        else
        {
            if (damageParticles != null && damageParticles.isPlaying)
                damageParticles.Stop();
        }
    }
}
```

### Como criar o Prefab

1. Crie um GameObject vazio: `Colossus > RoomModule_Motor`.
2. Adicione um cubo (Cube) como filho para visualização.
3. Adicione um `BoxCollider` ao cubo.
4. Anexe o script `RoomModule.cs` ao GameObject raiz.
5. Crie um `ParticleSystem` como filho para efeitos de dano.
6. Salve como prefab em `Assets/Prefabs/Colossus/RoomModule.prefab`.

---

## 4. Passo 2: Implementar o Sistema de Motor

### Script: `EngineSystem.cs`

```csharp
using UnityEngine;
using Unity.Netcode;
using System.Collections;

public class EngineSystem : NetworkBehaviour
{
    public enum EngineState { Offline, Starting_Step1, Starting_Step2, Starting_Step3, Running, Stalling }
    
    public NetworkVariable<int> currentState = new NetworkVariable<int>(0); // 0=Offline
    public NetworkVariable<float> currentFuel = new NetworkVariable<float>(100f);
    public NetworkVariable<float> currentEnergy = new NetworkVariable<float>(100f);
    
    public float maxFuel = 200f;
    public float maxEnergy = 200f;
    public float fuelConsumptionPerMin = 5f;
    public float energyConsumptionPerMin = 10f;
    
    private float step1Duration = 30f; // segundos
    private float step2Duration = 40f;
    private float step3Duration = 20f;
    
    private float stepTimer = 0f;
    private AudioSource engineAudioSource;
    private AudioClip engineLoopClip, engineStartClip;
    
    public override void OnNetworkSpawn()
    {
        engineAudioSource = GetComponent<AudioSource>();
        engineLoopClip = Resources.Load<AudioClip>("Audio/EngineLoop");
        engineStartClip = Resources.Load<AudioClip>("Audio/EngineStart");
        
        currentState.OnValueChanged += OnEngineStateChanged;
    }
    
    private void Update()
    {
        if (!IsServer) return;
        
        EngineState state = (EngineState)currentState.Value;
        
        // Processar estado atual
        switch (state)
        {
            case EngineState.Starting_Step1:
            case EngineState.Starting_Step2:
            case EngineState.Starting_Step3:
                stepTimer += Time.deltaTime;
                float targetDuration = state switch
                {
                    EngineState.Starting_Step1 => step1Duration,
                    EngineState.Starting_Step2 => step2Duration,
                    EngineState.Starting_Step3 => step3Duration,
                    _ => 0
                };
                
                if (stepTimer >= targetDuration)
                {
                    AdvanceEngineStep();
                }
                break;
            
            case EngineState.Running:
                ConsumeFuel();
                ConsumeEnergy();
                break;
        }
    }
    
    [ServerRpc(RequireOwnership = false)]
    public void StartEngineSequenceServerRpc()
    {
        if (currentState.Value != 0) return; // Apenas se estiver Offline
        
        currentState.Value = 1; // Starting_Step1
        stepTimer = 0f;
        Debug.Log("Motor: Iniciando Passo 1");
        PlayEngineStartAudioClientRpc();
    }
    
    private void AdvanceEngineStep()
    {
        EngineState state = (EngineState)currentState.Value;
        
        switch (state)
        {
            case EngineState.Starting_Step1:
                currentState.Value = 2; // Step2
                stepTimer = 0f;
                Debug.Log("Motor: Avançando para Passo 2");
                break;
            
            case EngineState.Starting_Step2:
                currentState.Value = 3; // Step3
                stepTimer = 0f;
                Debug.Log("Motor: Avançando para Passo 3");
                break;
            
            case EngineState.Starting_Step3:
                currentState.Value = 4; // Running
                Debug.Log("Motor: LIGADO!");
                break;
        }
    }
    
    private void ConsumeFuel()
    {
        float consumption = (fuelConsumptionPerMin / 60f) * Time.deltaTime;
        currentFuel.Value -= consumption;
        
        if (currentFuel.Value <= 0)
        {
            currentFuel.Value = 0;
            StallEngine();
        }
    }
    
    private void ConsumeEnergy()
    {
        float consumption = (energyConsumptionPerMin / 60f) * Time.deltaTime;
        currentEnergy.Value -= consumption;
    }
    
    private void StallEngine()
    {
        currentState.Value = 5; // Stalling
        Debug.Log("Motor: PANE!");
    }
    
    private void OnEngineStateChanged(int oldState, int newState)
    {
        Debug.Log($"Motor mudou de estado: {(EngineState)oldState} -> {(EngineState)newState}");
    }
    
    [ClientRpc]
    private void PlayEngineStartAudioClientRpc()
    {
        if (engineAudioSource && engineStartClip)
        {
            engineAudioSource.PlayOneShot(engineStartClip);
        }
    }
}
```

---

## 5. Passo 3: Controlador de Movimento

### Script: `ColossusController.cs`

```csharp
using UnityEngine;
using Unity.Netcode;

public class ColossusController : NetworkBehaviour
{
    public float maxSpeed = 30f; // km/h
    public float acceleration = 5f;
    public float rotationSpeed = 2f;
    
    private Vector3 currentVelocity = Vector3.zero;
    private EngineSystem engineSystem;
    
    public override void OnNetworkSpawn()
    {
        engineSystem = GetComponent<EngineSystem>();
    }
    
    private void Update()
    {
        if (!IsOwner) return;
        
        // Input do piloto
        float forwardInput = Input.GetAxis("Vertical");
        float turnInput = Input.GetAxis("Horizontal");
        
        SendPilotInputServerRpc(forwardInput, turnInput);
    }
    
    [ServerRpc]
    private void SendPilotInputServerRpc(float forwardInput, float turnInput)
    {
        if (engineSystem.currentState.Value != (int)EngineSystem.EngineState.Running)
        {
            // Motor não está ligado, não se move
            return;
        }
        
        // Calcular velocidade alvo
        float targetSpeed = forwardInput * maxSpeed;
        currentVelocity.z = Mathf.Lerp(currentVelocity.z, targetSpeed, acceleration * Time.deltaTime);
        
        // Rotação
        float yaw = turnInput * rotationSpeed * Time.deltaTime;
        transform.Rotate(0, yaw, 0);
        
        // Movimento
        transform.Translate(currentVelocity * Time.deltaTime, Space.Self);
        
        // Atrito natural
        if (Mathf.Abs(forwardInput) < 0.1f)
        {
            currentVelocity.z *= 0.95f;
        }
        
        UpdatePositionClientsRpc(transform.position, transform.rotation);
    }
    
    [ClientRpc]
    private void UpdatePositionClientsRpc(Vector3 newPosition, Quaternion newRotation)
    {
        if (IsServer) return; // Servidor já tem estado correto
        
        transform.position = newPosition;
        transform.rotation = newRotation;
    }
}
```

---

## 6. Passo 4: Rede e Network Manager

### Script: `NetworkManager.cs`

```csharp
using UnityEngine;
using Unity.Netcode;
using Unity.Netcode.Transports.UTP;

public class DustbornNetworkManager : MonoBehaviour
{
    public static DustbornNetworkManager Instance { get; private set; }
    
    private void Awake()
    {
        if (Instance != null && Instance != this)
        {
            Destroy(gameObject);
            return;
        }
        Instance = this;
    }
    
    public void StartHost()
    {
        NetworkManager.Singleton.StartHost();
        Debug.Log("Host iniciado");
    }
    
    public void StartClient(string ipAddress = "127.0.0.1")
    {
        var transport = NetworkManager.Singleton.GetComponent<UnityTransport>();
        transport.SetConnectionData(ipAddress, 7777);
        NetworkManager.Singleton.StartClient();
        Debug.Log($"Cliente conectando a {ipAddress}");
    }
    
    public void Shutdown()
    {
        NetworkManager.Singleton.Shutdown();
    }
}
```

---

## 7. Teste Local — Passo a Passo

### Setup de Cena

1. **Crie uma cena vazia**: `Assets/Scenes/ColossusPrototype.unity`.
2. **Adicione NetworkManager**: 
   - Crie um GameObject vazio chamado `NetworkManager`.
   - Adicione os componentes: `NetworkManager`, `UnityTransport`.
   - Configure Network Manager como prefab.
3. **Adicione o Colosso**:
   - Crie um GameObject vazio chamado `Colossus`.
   - Adicione o script `ColossusController`.
   - Adicione o script `EngineSystem`.
   - Adicione um `AudioSource` (para motor).
4. **Instâncie cômodos**:
   - Arraste o prefab `RoomModule` como filho do Colosso 3x (Motor, Oficina, Dormitório).

### Teste de Motor (Local)

```
1. Play em Editor.
2. Veja logs no Console: "Motor: Iniciando Passo 1"
3. Aguarde 30s, veja: "Motor: Avançando para Passo 2"
4. Aguarde 40s, veja: "Motor: Avançando para Passo 3"
5. Aguarde 20s, veja: "Motor: LIGADO!"
```

### Teste de Movimento (Local com Host+Client)

1. Abra 2 instâncias do Editor (Play + Play in Editor).
2. Na primeira: `DustbornNetworkManager.Instance.StartHost()`.
3. Na segunda: `DustbornNetworkManager.Instance.StartClient("127.0.0.1")`.
4. No host, controle o Colosso com WASD.
5. No cliente, veja o Colosso se mover em sincronismo.

---

## 8. Integração de UI — HUD Simples

### Script: `ColossusHUD.cs`

```csharp
using UnityEngine;
using TMPro;
using Unity.Netcode;

public class ColossusHUD : MonoBehaviour
{
    [SerializeField] private TextMeshProUGUI engineStateText;
    [SerializeField] private TextMeshProUGUI fuelText;
    [SerializeField] private TextMeshProUGUI energyText;
    [SerializeField] private TextMeshProUGUI roomIntegrityText;
    
    private EngineSystem engineSystem;
    private RoomModule[] rooms;
    
    private void Start()
    {
        engineSystem = FindObjectOfType<EngineSystem>();
        rooms = FindObjectsOfType<RoomModule>();
    }
    
    private void Update()
    {
        if (!engineSystem) return;
        
        // Atualizar textos
        string stateName = ((EngineSystem.EngineState)engineSystem.currentState.Value).ToString();
        engineStateText.text = $"Motor: {stateName}";
        fuelText.text = $"Combustível: {engineSystem.currentFuel.Value:F1}/{engineSystem.maxFuel}L";
        energyText.text = $"Energia: {engineSystem.currentEnergy.Value:F1}/{engineSystem.maxEnergy}";
        
        string roomStatus = "";
        foreach (var room in rooms)
        {
            roomStatus += $"{room.roomName}: {room.currentIntegrity.Value:F0}% ";
        }
        roomIntegrityText.text = roomStatus;
    }
}
```

---

## 9. Milestones de Sprint (MVP — 12 semanas)

### Sprint 1 (2 semanas): Protótipo do Colosso Básico
**Goal**: Colosso movendo com motor em 3 etapas.

- [x] RoomModule funcionando (prefab, dano, reparo).
- [x] EngineSystem com 3 etapas de ativação.
- [x] ColossusController — movimento sem frenagem automática.
- [x] Network Manager básico (Host/Client).
- [x] HUD mostrando estado do motor.
- [ ] **Teste**: 1 jogador pilota Colosso, vê motor ligar em 90s.

### Sprint 2 (3 semanas): Multiplayer Básico
**Goal**: 3 jogadores sincronizados, roles funcionando.

- [ ] NetworkColossusManager — sincronização de estado.
- [ ] Sistema de Roles (Piloto, Engenheiro, Atirador).
- [ ] Tarefas cooperativas básicas (ignição em etapas com mais de 1 jogador).
- [ ] Painel do Colosso (UI multi-usuário).
- [ ] Testes com 3 clientes.

### Sprint 3 (3 semanas): Crafting e Dano
**Goal**: Cômodos podem danificar e reparar.

- [ ] Sistema de colisão — dano ao Colosso por impacto.
- [ ] Oficina — crafting básico (reparar com kits).
- [ ] Inventário compartilhado (módulos do Colosso).
- [ ] Clima básico — tempestade com redução de visão.

### Sprint 4 (4 semanas): Zona Inicial Jogável
**Goal**: 1 zona completa com inimigos e miniboss.

- [ ] Mapa pequeno (deserto inicial).
- [ ] 2 tipos de inimigos básicos.
- [ ] 1 miniboss (Reaver Leader).
- [ ] Testes de coop integral (Colosso + exploração + combate).

### Sprint 5 (polishing): Otimização e Testes
- [ ] Performance optimization.
- [ ] Testes de carga (6 jogadores).
- [ ] Bug fixes.

---

## 10. Checklist Técnico para Começar

- [ ] Engine escolhida instalada (Unity 2022+ recomendado).
- [ ] Projeto criado com Netcode for GameObjects.
- [ ] Estrutura de pastas criada.
- [ ] RoomModule.cs compilado e testado.
- [ ] EngineSystem.cs compilado e testado.
- [ ] ColossusController.cs compilado e testado.
- [ ] Cena de teste criada.
- [ ] NetworkManager configurado.
- [ ] Primeiro teste local (Host + Client) executado.
- [ ] Logs de motor aparecendo no Console.

---

## 11. Riscos e Mitigações

| Risco | Impacto | Mitigação |
|-------|--------|-----------|
| Sincronização de rede instável | Alto | Testar com Netcode profiler regularmente; implementar buffering de estado. |
| Física do Colosso glitching | Médio | Testar colisões com mundo; usar Rigidbody kinematic se necessário. |
| Performance com múltiplos jogadores | Médio | Implementar LOD cedo; usar Object pooling para projéteis/efeitos. |
| Multiplicação de bugs em multiplayer | Alto | Criar build de teste dedicada; usar servidor de teste separado. |

---

## 12. Próximas Leituras

- [Unity Netcode Docs](https://docs.unity.com/netcode/)
- [Colossus Architecture Document](./ARCHITECTURE_COLOSSUS.md)
- [GDD Dustborn v1.1](./GDD_Dustborn_v1.1.md)

---

**Versão**: 1.0  
**Data**: 16 de Novembro de 2025  
**Status**: Pronto para implementação
