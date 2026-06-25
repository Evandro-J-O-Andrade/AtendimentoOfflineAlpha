# MD-130 — Clinical Panels Architecture

## Status
Documento Canônico da Plataforma. Motor de exibição clínica.

## Classificação
```text
Tipo: Capability Architecture
Camada: Shared Capabilities
Prioridade: Alta
Obrigatoriedade: HIS Context
```

---

## Objetivo
Painéis clínicos são motor de exibição distribuída. Distribuídos não centralizados.

---

## Lei Canônica MD-130-001
```text
Painel é motor de exibição clínica.
Distribuição não é centralização.
Contexto determina conteúdo.
```

---

## Panel Types

```text
Recepção
├── Fila de senhas
├── Chamadas pendentes
└── Informações gerais

Triagem
├── Classificação crítica
├── Fluxo atual
├── Tempo de espera
└── Pacientes prioritários

Consultório
├── Próximo paciente
├── Dados do paciente
├── Histórico recente
└── Alertas clínicos

Observação
├── Pacientes críticos
├── Monitoramento ativo
└── Transferências pendentes
```

---

## Integrações
| MD | Finalidade |
|----|---|
| MD-125 | Enterprise Display Architecture |
| MD-140 | Healthcare Operational Flow |
| MD-142 | Unified Enterprise Operating System |