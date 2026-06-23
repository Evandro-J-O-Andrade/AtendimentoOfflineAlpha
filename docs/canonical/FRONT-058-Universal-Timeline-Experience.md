# FRONT-058 — Universal Timeline Experience

## Status

Documento Canônico de Frontend.
Define a experiência de Timeline Universal da plataforma.

---

## Objetivo

Cada entidade importante da plataforma possui linha do tempo completa, rastreável e auditável.

---

## Princípio Fundamental

```text
Sem timeline não existe rastreabilidade.
Sem rastreabilidade não existe confiança.
Sem confiança não existe plataforma enterprise.
```

---

## Entidades com Timeline

| Entidade | Exemplos de Eventos |
|----------|---------------------|
| Paciente | Senha, atendimento, triagem, prescrição, dispensação, exame, alta |
| Cliente | Lead, contato, proposta, contrato, chamado, compra, pagamento |
| Usuário | Login, perfil, permissão, contexto, ações, treinamentos |
| Contrato | Criação, assinatura, renovação, alteração, cancelamento |
| Chamado | Abertura, atribuição, resposta, escalonamento, resolução, fechamento |
| Documento | Criação, revisão, aprovação, publicação, atualização, arquivamento |
| Ordem de Serviço | Abertura, execução, pausa, retomada, conclusão |
| Projeto | Kickoff, milestone, entrega, revisão, fechamento |
| Treinamento | Matrícula, início, progresso, conclusão, certificado |
| Aprovacao | Solicitação, análise, aprovação/reprovação, execução |

---

## Componentes

### TimelineView

```text
Visualização vertical (linha do tempo)
Cada evento como card:
  - Ícone por tipo
  - Título
  - Descrição
  - Autor/profissional
  - Timestamp
  - Contexto (unidade, local)
  - Anexos (se houver)
Agrupamento:
  - Por data (hoje, ontem, esta semana, anteriores)
  - Por tipo (clínico, administrativo, financeiro)
  - Por autor
```

### TimelineFilter

```text
Filtros:
  - Por tipo de evento
  - Por período
  - Por autor
  - Por unidade/local
  - Por status
Busca dentro da timeline
Export da timeline (PDF, CSV)
```

### TimelineDetail

```text
Modal ou painel lateral com detalhes:
  - Dados completos do evento
  - Antes e depois (diff)
  - Anexos e documentos
  - Comentários
  - Ações relacionadas
  - Próximos eventos (agendados)
```

### TimelineExport

```text
Export completo para:
  - PDF ( branded )
  - CSV (dados brutos)
  - JSON (integração)
Inclui:
  - Todos os eventos do período
  - Metadados de auditoria
  - Assinatura digital
```

---

## Regras

### Imutabilidade

```text
Eventos são imutáveis.
Nenhum evento é editado.
Nenhum evento é deletado.
Correções são registradas como NOVOS eventos:
  - "Correção: prescrição atualizada"
  - "Cancelamento: atendimento cancelado"
  - "Reabertura: chamado reaberto"
Timeline preserva história completa.
```

### Acesso

```text
Filtrado por tenant.
Filtrado por unidade/local.
Filtrado por perfil.
Dados sensíveis mascarados.
Log de acesso à timeline.
```

### Performance

```text
Paginação infinita (scroll)
Lazy load de eventos antigos
Cache de eventos recentes (últimos 30 dias)
Índice composto por (entidade, timestamp)
```

---

## Integrações

| MD / FRONT | Finalidade |
|-----------|-----------|
| MD-104 — Event Convergence Architecture | Eventos canônicos |
| MD-025 — Event Store Core | Armazenamento |
| MD-016 — Auditoria | Auditoria imutável |
| MD-110 — Canonical Laws | Leis supremas |
| FRONT-053 — Patient 360 | Timeline clínica |
| FRONT-051 — Customer 360 | Timeline comercial |
| FRONT-052 — Employee 360 | Timeline de RH |

---

## Responsabilidades

| Camada | Responsabilidade |
|--------|------------------|
| Frontend | TimelineView, Filtros, Detalhes, Export |
| Backend | APIs de timeline, paginação, filtros |
| Dispatcher | Roteamento para SPs e Event Store |
| SP | Regras de acesso, agregação de eventos |
| Event Store | Fonte de eventos imutáveis |
| IA | Resumo de timeline, detecção de padrões |

---

## Métricas

```text
Timelines acessadas por dia
Eventos por timeline (média)
Filtros mais usados
Exports por timeline
Drill-downs por evento
Tempo para carregar timeline (P95)
Satisfação com timeline (CSAT)
```

---

## Lei

```text
Sem timeline não existe rastreabilidade.
Sem rastreabilidade não existe confiança.
Timeline é a memória da entidade.
Timeline é imutável.
Timeline é auditável.
```

---

## Próximo

```text
FRONT-058 completo
  ↓
FRONT-059 — Enterprise Search AI
```
