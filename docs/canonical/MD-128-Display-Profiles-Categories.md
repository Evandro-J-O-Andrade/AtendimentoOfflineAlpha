# MD-128 — Display Profiles and Categories

## Status
Documento Canônico da Plataforma. Perfis e categorias de displays.

## Classificação
```text
Tipo: Capability Architecture
Camada: Shared Capabilities
Prioridade: Alta
Obrigatoriedade: Global
```

---

## Objetivo
Categorias de painéis são canais de comunicação. Public, Clinical, Management, Operational.

---

## Lei Canônica MD-128-001
```text
Painel não é senha.
Painel é canal de comunicação.
Categoria determina conteúdo.
```

---

## Panel Categories

```text
Public
├── Institucional
├── Branding
├── Boas-vindas
└── Informação Geral

Clinical
├── Senhas
├── Classificação
├── Fluxo
└── Alertas

Management
├── KPIs
├── Relatórios
├── Metas
└── Análises

Operational
├── Chamadas
├── Comunicados
├── Campanhas
└── Emergências
```

---

## Profile Configuration

```text
Profile
├── Display Type
├── Content Categories
├── Event Subscriptions
├── Interaction Mode
└── Offline Behavior
```

---

## Integrações
| MD | Finalidade |
|----|---|
| MD-126 | Display Authentication Architecture |
| MD-129 | Public Communication Panels |
| MD-130 | Operational Communication Center |