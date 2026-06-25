# MD-140 — Healthcare Operational Flow

## Status
Documento Canônico do Domínio. Fluxo canônico assistencial.

## Classificação
```text
Tipo: Domain Architecture
Camada: Domain Layer
Prioridade: Máxima
Obrigatoriedade: HIS Context
```

---

## Objetivo
Fluxo assistencial canônico: Senha → GPAT → FFA → Atendimento.

---

## Lei Canônica MD-140-001
```text
Fluxo é linear: Senha → Triagem → Classificação → Atendimento.
GPAT é aprovação de atendimento.
FFA é classificação de risco.
Contexto determina roteamento.
```

---

## Flow Stages

```text
Stage 1: Senha
├── Evento: SenhaEmitida
├── Dados: Paciente + Unidade
└── Próximo: Triagem

Stage 2: GPAT
├── Evento: GPATRealizado
├── Dados: Motivo + Prioridade
└── Próximo: Classificação

Stage 3: FFA
├── Evento: FFARealizada
├── Dados: Risco + Categoria
└── Próximo: Atendimento

Stage 4: Atendimento
├── Evento: AtendimentoIniciado
├── Dados: Profissional + Local
└── Próximo: Resolução
```

---

## Event Chain

```text
SenhaEmitida
→ GPATRealizado (causation)
→ FFARealizada (causation)
→ AtendimentoIniciado (causation)
→ ReceitaEmitida (causation)
→ DispensacaoRealizada (causation)
```

---

## Integrações
| MD | Finalidade |
|----|---|
| MD-136 | Event Driven Enterprise |
| MD-137 | Clinical Audit Architecture |
| MAP-011 | HIS Domain Architecture |
| MAP-012 | GPAT Architecture |
| MAP-013 | FFA Architecture |