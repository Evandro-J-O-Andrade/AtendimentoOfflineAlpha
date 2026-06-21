# MD-054 — Knowledge Graph

## Status

Documento Canônico do Grafo de Conhecimento da Plataforma Enterprise.

---

## Objetivo

Mapear e relacionar todas as entidades da plataforma.

Entidades, relacionamentos, contexto.

Fundação para IA contextual, busca inteligente e insights.

---

## Princípio Fundamental

```text
Toda entidade pode se relacionar
com qualquer outra entidade.

O grafo é a memória
da plataforma.
```

---

## Knowledge Graph Architecture

```text
Entity Layer
    ↓
Relationship Layer
    ↓
Context Layer
    ↓
Inference Engine
    ↓
Query Layer
    ↓
Consumers (IA, Search, Analytics, Apps)
```

---

## Core Entities

### Pessoas

```text
Usuario
Cliente
Contato
Fornecedor
Parceiro
Profissional (HIS)
Paciente
```

### Organizacional

```text
Tenant
Unidade
Local
Departamento
Equipe
Cargo
Perfil
```

### Negócio

```text
Cliente
Lead
Oportunidade
Contrato
Produto
Servico
Projeto
Pedido
Fatura
```

### Operacional

```text
Chamado
Incidente
Ticket
Ativo
Patrimonio
OrdemServico
Manutencao
```

### Conhecimento

```text
Documento
Wiki_Pagina
Curso
Certificado
FAQ
Solucao
BaseConhecimento
Manual
Politica
```

### Social

```text
Post
Comentario
Comunidade
Canal
Mensagem
Evento
Enquete
```

### Digital

```text
App
Action
Workflow
Integracao
API
Webhook
Agente_IA
```

---

## Relationship Types

### Organizacional

```text
TRABALHA_EM (usuário → unidade)
PERTENCE_A (usuário → departamento)
GERENCIA (usuário → equipe)
SUPERVISIONA (usuário → usuário)
```

### Negocial

```text
CONTRATOU (cliente → contrato)
POSSUI (cliente → produto)
SOLICITOU (cliente → ticket)
AVANCOU (lead → oportunidade)
COMPROU (cliente → pedido)
PAGOU (cliente → fatura)
```

### Social

```text
POSTOU (usuário → post)
COMENTOU (usuário → comentário)
REAGIU (usuário → reação)
MEMBRO_DE (usuário → comunidade)
ENVIOU (usuário → mensagem)
CONVIDOU (usuário → evento)
```

### Conhecimento

```text
AUTOR_DE (usuário → documento)
CONCLUIU (usuário → curso)
CERTIFICOU (usuário → certificado)
RESPONDEU (usuário → FAQ)
CONSULTOU (usuário → documento)
APLICOU (documento → política)
```

### Digital

```text
EXECUTOU (usuário → action)
USOU (usuário → app)
ACESSOU (usuário → API)
CONFIGUROU (usuário → workflow)
OPEROU (agente_ia → execução)
```

### Temporal

```text
ACONTECEU_EM (evento → departamento)
VIGENTE_EM (contrato → período)
ATIVO_EM (usuário → período)
RESPONSAVEL_EM (usuário → período)
```

---

## Graph Model

### Entity Node

```json
{
  "node_id": "UUID",
  "type": "USUARIO|CLIENTE|DOCUMENTO|...",
  "tenant_id": 0,
  "attributes": {},
  "embeddings": [],
  "created_at": "datetime",
  "updated_at": "datetime"
}
```

### Relationship Edge

```json
{
  "edge_id": "UUID",
  "source_id": "UUID",
  "target_id": "UUID",
  "type": "TRABALHA_EM|SOLICITOU|...",
  "attributes": {},
  "weight": 0.0,
  "tenant_id": 0,
  "valid_from": "datetime",
  "valid_to": "datetime",
  "created_at": "datetime"
}
```

---

## Inference Engine

### Inference Rules

```text
Co-workers: users in same department
Same-problem: tickets with same root cause
Same-interest: users consuming same content
Influence: posts with high engagement by user
Expert: users tagged as experts in topic
Relationship path: A → B → C chain
Community: users in same community
Skill: users with same certifications
```

### Inference Output

```json
{
  "source_id": "UUID",
  "target_id": "UUID",
  "relationship": "INFERRED_CO_WORKER",
  "confidence": 0.85,
  "path": ["TRABALHA_EM", "PERTENCE_A"],
  "tenant_id": 0,
  "inferred_at": "datetime"
}
```

---

## Graph Queries

### Common Queries

```text
Who can help with this ticket?
Who knows this topic?
What documents relate to this client?
What training does this user need?
Who are the influencers in this topic?
What is the dependency chain?
Who works with this person?
What happened before this event?
```

### Query Patterns

```text
Neighbors: direct connections
Paths: A to B via intermediate nodes
Clusters: communities within graph
Ranking: most connected entities
Prediction: likely future connections
Anomaly: unusual connection patterns
```

---

## Integration with Other MDs

- **MD-002 (Auth)**: identidade para nós de usuário.
- **MD-003 (Operational Context)**: contexto operacional.
- **MD-004 (Dispatcher)**: ações como edges.
- **MD-005 (Event Store)**: eventos como edges temporais.
- **MD-010 (Security)**: security filter para queries.
- **MD-014 / MD-019 (App Registry)**: apps como nós.
- **MD-016 (Auditoria)**: auditoria de queries.
- **MD-017 (MultiTenant)**: isolamento por tenant.
- **MD-020 (Portal Core)**: portal consome grafo.
- **MD-027 (AI Orchestration)**: IA usa grafo para contexto.
- **MD-028 (Enterprise Social)**: social como nós e edges.
- **MD-029 (Digital Workplace)**: workplace como nós.
- **MD-032 (Unified Communication)**: comunicação como edges.
- **MD-034 (IAM)**: permissões sobre grafo.
- **MD-035 (Security Trust Architecture)**: security.
- **MD-051 (Data Lake)**: dados para enriquecer grafo.
- **MD-053 (Enterprise Search)**: busca via grafo.

---

## Próximo MD recomendado

```text
MD-055 — Digital Twin Organization
```

Representação digital.

---

## Regras Canônicas

1. Knowledge Graph conecta toda a plataforma.
2. Toda entidade é um nó.
3. Toda relação é uma edge.
4. Grafo respeita tenant isolation.
5. Grafo respeita permissões.
6. Inference usa apenas dados permitidos.
7. Embeddings são gerados para busca semântica.
8. Graph é atualizado por eventos.
9. Graph é consultado por IA, Search e Apps.
10. Graph é auditado.
11. Relacionamentos são temporais.
12. Relacionamentos podem expirar.
13. Inference tem confidence score.
14. PII é tratado em nodes e edges.
15. Graph é patrimônio da plataforma.
16. Cross-tenant queries são proibidas.
17. Graph alimenta recomendações.
18. Graph alimenta busca.
19. Graph alimenta IA contextual.
20. Graph é vivo e cresce com uso.

---

## Proibições

São proibidos:

```text
Query cross-tenant sem autorização
Exposição de relacionamentos sensíveis
Inference sem confiança mínima
Graph sem PII masking
Consulta sem auditoria
Alteração sem eventos
Inference sem revisão humana em casos críticos
Graph usado para tracking não autorizado
Dados de fora da plataforma sem validação
Relationship sem tenant
```
