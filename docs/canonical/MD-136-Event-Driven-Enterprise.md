# MD-136 — Event Driven Enterprise

## Status
Documento Canônico da Plataforma. Eventos como fonte da história.

## Classificação
```text
Tipo: Foundation Architecture
Camada: Platform Core
Prioridade: Máxima
Obrigatoriedade: Global
```

---

## Objetivo
Eventos são a unidade de operação. Tudo é evento. Nada é apagado.

---

## Lei Canônica MD-136-001
```text
Todo comportamento gera evento.
Eventos são fonte da história.
Nada é deletado, apenas cancelado.
```

---

## Event Taxonomy

```text
Domain Events
├── HIS
│   ├── SenhaEmitida
│   ├── PacienteAtendido
│   ├── ClassificacaoRealizada
│   └── InternacaoSolicitada
├── Farmacia
│   ├── ReceitaEmitida
│   ├── DispensacaoRealizada
│   └── EstoqueBaixo
└── Financeiro
    ├── FaturaGerada
    ├── PagamentoRecebido
    └── EstornoRealizado
```

---

## Event Schema Standard

```json
{
  "eventId": "uuid",
  "eventType": "Domain.Action.State",
  "timestamp": "ISO8601",
  "actor": { "type": "Pessoa/Papel/System", "id": "uuid" },
  "context": { "unidadeId": "uuid", "setorId": "uuid", "areaId": "uuid" },
  "payload": {},
  "metadata": { "correlationId": "uuid", "causationId": "uuid", "source": "string" }
}
```

---

## Integrações
| MD | Finalidade |
|----|---|
| MD-137 | Clinical Audit Architecture |
| MD-138 | Immutable Clinical Records |
| MD-132 | Operational Communication Center |
| MD-134 | Display Event Distribution Engine |