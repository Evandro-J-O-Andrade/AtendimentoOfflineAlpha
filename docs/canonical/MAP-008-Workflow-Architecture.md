# MAP-008 — Workflow Architecture

## Status
Documento Canônico de Arquitetura.
Arquitetura de workflows e automação.

---

## Classificação
```text
Tipo: Domain Architecture
Camada: Plataforma
Prioridade: Alta
Obrigatoriedade: Global
```

---

## Objetivo
Definir arquitetura de workflows como orquestração de processos de negócio.

---

## Lei Canônica MAP-008-001
```text
Todo workflow é visualizável.
```

---

## Componentes

### Workflow Definition
```text
workflow_id (UUID)
tenant_id
name
description
definition (JSON)
type (sequential/parallel/event-based)
is_active
version
```

### Workflow Instance
```text
instance_id (UUID)
workflow_id
tenant_id
state
current_step
context
started_at
completed_at
```

### Step
```text
step_id (UUID)
workflow_id
name
type
action
condition
next_steps
```

---

## Workflow Engine

### Execution Model
```text
Event-driven execution
Async steps
Parallel branches
Conditional routing
Error handling
```

### State Machine
```text
PENDING
RUNNING
WAITING
COMPLETED
FAILED
CANCELLED
```

---

## N8N Integration

### Runner Types
```text
Embedded N8N
External N8N
Hybrid
```

### Node Types
```text
Action
Condition
Event
Approval
Webhook
AI
```

---

## Stored Procedures

### sp_workflow_start
Iniciar workflow

### sp_workflow_complete_step
Completar etapa

### sp_workflow_transition
Transição de estado

### sp_workflow_get_instance
Obtém instância

---

## Eventos Oficiais

### WorkflowStarted
Workflow iniciado

### WorkflowStepCompleted
Etapa completada

### WorkflowCompleted
Workflow finalizado

### WorkflowFailed
Workflow falhou

### WorkflowCancelled
Workflow cancelado

---

## Integrações
| MAP/MD | Finalidade |
|--------|-----------|
| MD-089 — Workflow Fabric | Workflows |
| MAP-007 — Event Architecture | Eventos |
| FRONT-022 — Workflow Experience | UX |
| FRONT-048 — N8N Workspace | N8N |