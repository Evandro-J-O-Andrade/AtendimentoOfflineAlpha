# FRONT-056 — Digital Twin Experience

## Status

Documento Canônico de Frontend.
Define a experiência de Gêmeo Digital da plataforma.

---

## Objetivo

Representar digitalmente a operação física da organização para monitoramento, simulação e otimização.

---

## Princípio Fundamental

```text
Mundo real gera dados.
Dados alimentam o Digital Twin.
Digital Twin reproduz, simula e antecipa.
Antecipar é melhor que reagir.
```

---

## Componentes

### RealtimeMap

```text
Visualização geográfica/espacial:
  - Unidades (hospitais, clínicas, lojas)
  - Locais (setores, salas, guichês)
  - Recursos (leitos, equipamentos, veículos)
Status em tempo real:
  - Verde: normal
  - Amarelo: atenção
  - Vermelho: crítico
  - Cinza: offline/inativo
Clique para drill-down:
  - Unidade → Locais
  - Local → Recursos
  - Recurso → Histórico
```

### ResourceTracker

```text
Recursos rastreados:
  - Profissionais (médicos, enfermeiros)
  - Equipamentos (respiradores, monitores)
  - Veículos (ambulâncias)
  - Leitos
  - Salas
  - Guichês
Status:
  - Disponível
  - Ocupado
  - Em manutenção
  - Indisponível
Histórico de utilização
Previsão de disponibilidade
```

### SimulationEngine

```text
Simulações:
  - "E se aumentar demanda em 30%?"
  - "E se 3 profissionais faltarem?"
  - "E se leito X ficar indisponível?"
Resultados:
  - Capacidade máxima
  - Gargalos
  - Riscos
  - Recomendações
Visualização:
  - Mapas de calor
  - Fluxos animados
  - Alertas de saturação
```

### PredictiveAlerts

```text
Alertas preditivos (IA):
  - "Risco de lotação em 2h"
  - "Leito X inativo há 4h (manutenção preventiva)"
  - "Profissional Y em sobrecarga"
  - "Veículo Z com manutenção vencendo"
Priorização automática
Ações sugeridas
Integração com Notifications e Command Center
```

### HistoricalReplay

```text
Reprodução de cenários passados:
  - "Como estava a unidade ontem às 14h?"
  - "Qual foi o pico de atendimentos na pandemia?"
Uso:
  - Treinamento
  - Análise de incidente
  - Planejamento de capacidade
```

---

## Regras

### Dados

```text
Fonte: Event Store (kernel_ledger).
Sensores e dispositivos alimentam via Integration Hub.
Dados são stream em tempo real (WebSocket/SSE).
Histórico retido para replay.
Anonimização quando necessário (LGPD).
```

### Visualização

```text
Responsiva: desktop, tablet, TV (painel).
Zoom: macro (cidade/região) → micro (sala/leito).
Legenda clara.
Cores semânticas (verde/amarelo/vermelho/cinza).
Acessibilidade: alto contraste, screen reader.
```

### Simulação

```text
Baseada em regras de negócio + dados históricos.
IA aprende com simulações anteriores.
Resultados são probabilísticos, não determinísticos.
Sempre exibir grau de confiança.
```

---

## Integrações

| MD / FRONT | Finalidade |
|-----------|-----------|
| MD-055 — Digital Twin Organization | Documento canônico |
| MD-065 — Observability Platform | Métricas |
| MD-066 — SRE Platform | Infraestrutura |
| MD-083 — Integration Hub | Dados de sensores/dispositivos |
| MD-081 — AI Copilot | Alertas preditivos |
| MD-099 — Strategic Command Center | Command Center |
| MD-110 — Canonical Laws | Leis supremas |

---

## Responsabilidades

| Camada | Responsabilidade |
|--------|------------------|
| Frontend | Mapa, Tracker, Simulação, Alertas, Replay |
| Backend | APIs de dados em tempo real, simulação |
| Dispatcher | Roteamento para SPs e Analytics |
| SP | Regras de simulação, cálculo de capacidade |
| Event Store | Fonte de dados históricos e em tempo real |
| IA | Alertas preditivos, simulação inteligente |

---

## Métricas

```text
Unidades mapeadas
Recursos rastreados
Simulações executadas por dia
Alertas gerados vs. acionados
Precisão de alertas preditivos
Uso de replay (treinamento, análise)
Latência de atualização do mapa (P95)
Satisfação com Digital Twin (CSAT)
```

---

## Lei

```text
Mundo real gera dados.
Dados alimentam o Digital Twin.
Digital Twin reproduz, simula e antecipa.
Antecipar é melhor que reagir.
```

---

## Próximo

```text
FRONT-056 completo
  ↓
FRONT-057 — Smart Notification Experience
```
