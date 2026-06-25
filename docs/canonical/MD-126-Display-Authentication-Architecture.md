# MD-126 — Display Authentication Architecture

## Status
Documento Canônico da Plataforma. Autenticação canônica de displays.

## Classificação
```text
Tipo: Foundation Architecture
Camada: Platform Core
Prioridade: Máxima
Obrigatoriedade: Global
```

---

## Objetivo
Display autentica e entra no Portal de Displays. NÃO recebe URL fixa.

---

## Lei Canônica MD-126-001
```text
Display tem identidade própria.
Autenticação é obrigatória.
Portal de Displays é ponto de entrada.
```

---

## Authentication Flow

```text
1. Display inicializa
2. Envia device ID + certificado
3. Recebe JWT específico
4. Portal de Displays (entry point)
5. Recebe perfil associado
6. Recebe playlists
7. Inicia operação
```

---

## Identity Model

```text
Display Identity
├── UUID (device)
├── Serial (hardware)
├── MAC address
├── Profile association
└── Tenant binding
```

---

## Integrações
| MD | Finalidade |
|----|---|
| MD-125 | Enterprise Display Architecture |
| MD-002 | Autenticação |
| MD-128 | Display Profiles and Categories |