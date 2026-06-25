# MD-137 — Clinical Audit Architecture

## Status
Documento Canônico do Domínio. Rastreabilidade total.

## Classificação
```text
Tipo: Foundation Architecture
Camada: Domain Layer
Prioridade: Máxima
Obrigatoriedade: HIS Context
```

---

## Objetivo
Todo comportamento clínico é rastreável. Sem exceções.

---

## Lei Canônica MD-137-001
```text
Toda ação clínica gera evento.
Evento tem origem e correlação.
Nada entra sem rastrear.
Nada sai sem auditoria.
```

---

## Audit Dimensions

```text
Who
├── Pessoa (não Usuário)
├── Papel no momento
└── Session binding

What
├── EventType
├── Payload changes
└── Before/After

Where
├── Unidade
├── Setor
├── Área
└── Display (if applicable)

When
├── Timestamp
├── Business time
└── System time
```

---

## Integrações
| MD | Finalidade |
|----|---|
| MD-136 | Event Driven Enterprise |
| MD-138 | Immutable Clinical Records |
| MAP-011 | HIS Domain Architecture |