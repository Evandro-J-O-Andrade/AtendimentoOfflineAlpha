# FRONT-023 — Approval Center

## Status

Documento Canônico de Frontend.
Define a central única de aprovações da plataforma.

---

## Objetivo

Centralizar todas as aprovações da plataforma em único painel com estados claros.

---

## Princípio Fundamental

```text
Aprovação não é dispersa.
Aprovação é centralizada.
Aprovação é rastreável.
Aprovação é decisiva.
Aprovação é auditada.
```

---

## Componentes

### ApprovalInbox

```text
Lista de aprovações pendentes
Filtro por tipo (documento, workflow, compra, contrato)
Ordenação por data, prioridade, solicitante
Contador de pendentes no header
Badge no ícone de notificação
```

### ApprovalCard

```text
Título do item a ser aprovado
Descrição/resumo
Solicitante
Data da solicitação
Prazo (quando aplicável)
Anexos
Histórico de aprovação
```

### ApprovalModal

```text
Visualização completa do item
Detalhes expandidos
Comentários obrigatórios (quando configurado)
Aprovar com um clique
Reprovar com justificativa
Solicitar ajustes
```

### ApprovalHistory

```text
Timeline de aprovações concluídas
Filtro por estado (aprovado, reprovado, cancelado)
Busca por aprovador ou item
Export de histórico
Reabrir aprovação (admin)
```

---

## Estados

| Estado | Comportamento |
|--------|---------------|
| Pendente | Aguardando aprovação, prazo visível |
| Aprovado | Check verde, data/hora do aprovador |
| Reprovado | X vermelho, justificativa obrigatória |
| Cancelado | Strike-through, não pode ser aprovado |
| Atrasado | Badge warning, notificação ao solicitante |
| Vencido | Badge danger, não aprovável |

---

## Tipos de Aprovação

```text
Compras: orçamento, fornecedor, valor
Contratos: cláusulas, vigência, partes
Documentos: versão, coautor, conteúdo
Financeiro: pagamento, recebimento, desconto
RH: admissão, demissão, benefício
Treinamentos: matrícula, certificado, prorrogação
```

---

## Regras

### Obrigatório

```text
Toda aprovação aparece no Approval Center
Reprovação exige justificativa
Histórico é imutável
Notificação automática ao mudar estado
Prazo é visível e alerta são disparados
```

### Proibido

```text
Aprovação sem histórico
Reprovação sem justificativa (quando exigido)
Cancelamento sem motivo (admin)
Alteração de histórico existente
Notificação para aprovação aprovada
```

---

## Integrações

| MD / FRONT | Finalidade |
|-----------|-----------|
| MD-050 — Approval Workflow Platform | Plataforma de aprovação |
| MD-025 — Document Management Platform | Aprovação de documentos |
| MD-030 — Workflow Engine | Workflows com aprovação |
| MD-088 — Procurement System | Compras |
| MD-089 — HR Management | RH |
| MD-090 — Training Platform | Treinamentos |
| MD-052 — Audit Trail Architecture | Auditoria |
| MD-110 — Canonical Laws | Leis supremas |
| FRONT-021 — Enterprise Document Experience | Aprovação de documentos |
| FRONT-022 — Workflow Experience | Aprovação em workflows |

---

## Responsabilidades

| Camada | Responsabilidade |
|--------|------------------|
| Frontend | Inbox, cards, modal, histórico |
| Backend | APIs de aprovação, status, notificação |
| Dispatcher | Roteamento para SPs de aprovação |
| SP | Validação de regras, execução de aprovação |
| Event Store | Registrar aprovação, rejeição, cancelamento |

---

## Métricas

```text
Aprovações pendentes por usuário
Tempo médio de aprovação
Taxa de aprovação vs. reprovação
Aprovações vencidas
Aprovações atrasadas
Por tipo de aprovação
Por solicitante
Por aprovador
```

---

## Lei

```text
Aprovação é centralizada.
Aprovação é rastreável.
Aprovação é decisiva.
Aprovação é auditada.
```

---

## Próximo

```text
FRONT-023 completo
  ↓
FRONT-024 — AI Experience Framework
```