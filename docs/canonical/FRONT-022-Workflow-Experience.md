# FRONT-022 — Workflow Experience

## Status

Documento Canônico de Frontend.
Define a experiência visual para workflows na plataforma.

---

## Objetivo

Fornecer experiência visual para Workflows integrando N8N e Workflow Engine nativa.

---

## Princípio Fundamental

```text
Workflow não é código.
Workflow é visualização.
Workflow é compreensão.
Workflow é execução.
Workflow é monitoramento.
```

---

## Componentes

### FlowCanvas

```text
Área de desenho do workflow
Zoom e pan infinito
Grid snapping opcional
Conexões automáticas entre nós
Modo presentation (apresentação)
```

### StepNode

```text
Representação visual de etapa
Indicador de status (pendente, em execução, concluído, erro)
Duração estimada
Assignees visíveis
Ações rápidas
```

### ConditionNode

```text
Decisão binária ou múltipla
Expressão visual da condição
Preview do resultado
Teste de condição inline
```

### EventNode

```text
Gatilho externo
Webhook visual
Agendamento
Timer
File watcher
```

### ActionNode

```text
Execução de ação
API call
Database operation
Email send
Notification
Script
```

### ApprovalNode

```text
Nó de aprovação
Lista de aprovadores
Prazo de aprovação
Justificativa obrigatória (opcional)
Rejeição com motivo
```

---

## Visual

### Canvas Visual

```text
Área de desenho principal
Zoom (25% a 200%)
Pan com arrastar
Modo fullscreen disponível
Grid ocultável
```

### Drag and Drop

```text
Arrastar nós da paleta
Conectar nós com drag
Mover nós existentes
Clone de nós
Deletar com tecla Delete
```

### Timeline

```text
Linha do tempo horizontal
Etapas concluídas com check verde
Etapas em execução com spinner
Etapas pendentes com borda tracejada
Etapas com erro com X vermelho
```

### Logs

```text
Console de logs integrado
Filtro por nível (info, warn, error)
Busca em logs
Export de logs
Visualização de payload
```

---

## Regras

### Obrigatório

```text
Todo workflow é visualizável
Status é atualizado em tempo real
Logs são persistentes e auditáveis
Condições são testáveis inline
Ações têm retry automático
```

### Proibido

```text
Workflow sem visualização
Nó sem identificador único
Condição sem teste
Ação sem tratamento de erro
Log sem contexto
```

---

## Integrações

| MD / FRONT | Finalidade |
|-----------|-----------|
| MD-030 — Workflow Engine | Motor de workflows nativo |
| MD-031 — N8N Integration | Integração com N8N |
| MD-052 — Audit Trail Architecture | Auditoria de execuções |
| MD-065 — Observability Platform | Logs e métricas |
| MD-110 — Canonical Laws | Leis supremas |
| FRONT-021 — Enterprise Document Experience | Workflows em documentos |
| FRONT-023 — Approval Center | Aprovações em workflows |

---

## Responsabilidades

| Camada | Responsabilidade |
|--------|------------------|
| Frontend | Canvas, nós, conexões, timeline, logs |
| Backend | APIs de workflows, status, execução |
| Dispatcher | Roteamento para SPs de workflow |
| SP | Execução de nós, regras de condição |
| Event Store | Registrar execução, logs, erros |
| IA | Sugestões de otimização, detectação de gargalo |

---

## Métricas

```text
Workflows ativos
Workflows executados por dia
Taxa de sucesso por workflow
Tempo médio de execução
Nós mais lentos
Erros por tipo de nó
Logs gerados
Visualizações de workflow
```

---

## Lei

```text
Todo workflow deve ser visualizável.
```

---

## Próximo

```text
FRONT-022 completo
  ↓
FRONT-023 — Approval Center
```