# MD-133 — Speech and TTS Architecture

## Status
Documento Canônico da Plataforma. TTS canônico com fallback.

## Classificação
```text
Tipo: Capability Architecture
Camada: Shared Capabilities
Prioridade: Alta
Obrigatoriedade: Global
```

---

## Objetivo
TTS é serviço canônico. Primary Google, fallback System.

---

## Lei Canônica MD-133-001
```text
TTS é serviço oficial.
Primary é Google.
Secondary é Azure.
Tertiary é System.
Offline nunca quebra.
```

---

## TTS Pipeline

```text
TTS Service
├── Google TTS (primary)
├── Azure TTS (secondary)
├── AWS Polly (optional)
├── System TTS (offline fallback)
└── Audio Cache
```

---

## Voice Profiles

```text
Default Voice
├── Masculino/Feminino
├── Rate
├── Pitch
└── Volume
```

---

## Integrações
| MD | Finalidade |
|----|---|
| MD-132 | Operational Communication Center |
| MD-125 | Enterprise Display Architecture |