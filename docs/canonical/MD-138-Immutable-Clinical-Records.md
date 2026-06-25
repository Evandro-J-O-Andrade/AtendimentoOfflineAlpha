# MD-138 — Immutable Clinical Records

## Status
Documento Canônico do Domínio. Registros imutáveis.

## Classificação
```text
Tipo: Foundation Architecture
Camada: Domain Layer
Prioridade: Máxima
Obrigatoriedade: HIS Context
```

---

## Objetivo
Registros clínicos são imutáveis. Historia preservada, não sobrescrita.

---

## Lei Canônica MD-138-001
```text
Nenhum registro clínico é deletado.
Alterações são eventos de retificação.
Histórico é verdade.
Versão corrente é derivada.
```

---

## Record Lifecycle

```text
Create
├── Evento: RegistroCriado
└── State: Active

Update
├── Evento: RegistroRetificado
├── Payload: antes/depois
└── State: Active (dereference antigo)

Cancel
├── Evento: RegistroCancelado
├── Motivo: obrigatório
└── State: Cancelled (retain event)
```

---

## Integrações
| MD | Finalidade |
|----|---|
| MD-137 | Clinical Audit Architecture |
| MD-139 | Clinical Retification and Revocation Model |
| MAP-011 | HIS Domain Architecture |