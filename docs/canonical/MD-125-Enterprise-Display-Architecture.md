# MD-125 — Enterprise Display Architecture

## Status
Documento Canônico da Plataforma. Displays como canal oficial.

## Classificação
```text
Tipo: Foundation Architecture
Camada: Platform Core
Prioridade: Máxima
Obrigatoriedade: Global
```

---

## Objetivo
Display é canal oficial de comunicação operacional. NÃO é TV de senha.

---

## Lei Canônica MD-125-001
```text
Display é cidadão de primeira classe.
Toda comunicação sai pelo Display.
Display é gerenciado pelo Portal.
```

---

## Display Types

```text
TV - Recepção
├── Senhas
├── Chamadas
├── Mensagens
└── KPIs gerais

Totem - Setor
├── Senhas setoriais
├── Informações
└── Self-service

Kiosk - Ponto
├── Check-in
├── Consulta pública
└── FAQ

VideoWall - Grande área
├── KPIs corporativos
├── Comunicados
└── Branding

Monitor Clínico - Triagem
├── Classificação
├── Fluxo
└── Alertas

Tablet - Consultório
├── Agenda
├── Próximos
└── Dados do paciente
```

---

## Display Lifecycle

```text
Registration
├── Hardware detection
├── Profile assignment
└── Network config

Provisioning
├── Playlist assign
├── Content cache
└── Schedule

Runtime
├── Event stream
├── State sync
├── Offline mode
└── Health check

Management
├── Status monitor
├── Remote control
├── Playlist update
└── Emergency broadcast
```

---

## Integrações
| MD | Finalidade |
|----|---|
| MD-123 | Portal Canonical Experience |
| MD-126 | Display Management Domain |
| MD-127 | Operational Communication Center |
| MD-130 | Unified Enterprise Operating System |