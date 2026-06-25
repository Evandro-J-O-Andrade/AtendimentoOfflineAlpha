# MD-117 — Inpatient and Bed Management

## Status
Documento Canônico do Domínio. Gestão de leitos e internações.

## Classificação
```text
Tipo: Domain Architecture
Camada: Domain Layer
Prioridade: Alta
Obrigatoriedade: HIS Context
```

---

## Objetivo
Internação é agregado de leitos. Transferência é evento.

---

## Lei Canônica MD-117-001
```text
Leito é recurso limitado.
Internação é agregado.
Transferência é evento canônico.
Óbito não esquece histórico.
```

---

## Bed Lifecycle

```text
Available
→ Occupied (InternacaoIniciada)
→ Reserved (ReservaRealizada)
→ Blocked (Manutenção)
→ Available (Alta/Óbito)
```

---

## Event Model

```text
InternacaoIniciada
├── Paciente
├── Leito origem
├── Motivo
└── Previsão alta

TransferenciaRealizada
├── Paciente
├── Leito origem
├── Leito destino
├── Motivo
└── Classificacao

AltaRealizada
├── Internacao
├── Tipo: Curativa/Administrativa
├── Data alta
└── Followup

ObitoRegistrado
├── Internacao
├── Data óbito
├── Causa
└── Notificacao obrigatória
```

---

## Integrações
| MD | Finalidade |
|----|---|
| MD-115 | Healthcare Operational Flow |
| MD-116 | Healthcare Execution Domains |
| MAP-011 | HIS Domain Architecture |