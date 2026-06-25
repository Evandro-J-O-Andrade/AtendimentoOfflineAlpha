# MD-127 — Display Management Domain

## Status
Documento Canônico da Plataforma. Gestão canônica de displays.

## Classificação
```text
Tipo: Domain Architecture
Camada: Platform Core
Prioridade: Alta
Obrigatoriedade: Global
```

---

## Objetivo
Gestão centralizada de toda rede de displays.

---

## Lei Canônica MD-127-001
```text
Display é entidade gerenciável.
Playlist é workflow visual.
Campanha é blast unificado.
```

---

## Display Entity Model

```text
Display
├── Id: UUID
├── Type: TV/Totem/Kiosk/etc
├── Location: Physical + Logical
├── Status: Online/Offline/Error
├── Profile: Capability set
└── Context: Unidade/Setor
```

---

## Profile Types

```text
Profile: TV-Basic
├── Resolution: 1920x1080
├── Audio: Yes
├── Touch: No
└── Content: Senhas + Mensagens

Profile: Totem-Interactive
├── Resolution: 1080x1920
├── Audio: Optional
├── Touch: Yes
└── Content: Self-service + Senhas

Profile: Monitor-Clinical
├── Resolution: 1920x1080
├── Audio: No
├── Touch: No
└── Content: Classificação + Fluxo
```

---

## Integrações
| MD | Finalidade |
|----|---|
| MD-125 | Enterprise Display Architecture |
| MD-128 | Display Profiles and Categories |
| MD-129 | Public Communication Panels |