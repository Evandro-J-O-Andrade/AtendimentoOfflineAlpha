# MD-139 — Clinical Retification and Revocation Model

## Status
Documento Canônico do Domínio. Modelo canônico de cancelamento/retificação.

## Classificação
```text
Tipo: Foundation Architecture
Camada: Domain Layer
Prioridade: Alta
Obrigatoriedade: HIS Context
```

---

## Objetivo
Cancelamento e retificação são operação canônica. Não é delete.

---

## Lei Canônica MD-139-001
```text
Cancelamento não apaga.
Retificação não substitui.
Substituição referencia original.
Motivo é obrigatório.
```

---

## Operation Types

```text
CANCEL
├── RegistroCancelado event
├── Motivo obrigatório
├── Retain original
└── State: Cancelled

RETIFY
├── RegistroRetificado event
├── Before/After payload
├── Retain original
└── State: Retified

REPLACE
├── RegistroSubstituido event
├── Versão anterior/anterior
├── Link para novo
└── State: Replaced
```

---

## Integrações
| MD | Finalidade |
|----|---|
| MD-138 | Immutable Clinical Records |
| MD-137 | Clinical Audit Architecture |
| MD-136 | Event Driven Enterprise |