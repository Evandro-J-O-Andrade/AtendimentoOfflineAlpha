# MD-053 — Enterprise Search

## Status

Documento Canônico de Busca Enterprise da Plataforma.

---

## Objetivo

Criar uma única barra de busca capaz de encontrar qualquer conteúdo da plataforma.

Pessoas, documentos, tickets, cursos, posts, chats, apps.

Tudo indexado, tudo buscável.

---

## Lei Fundamental

```text
Uma única barra de pesquisa
para todo o ecossistema.

Nenhuma informação fica invisível
quando o usuário tem permissão.
```

---

## Enterprise Search Architecture

```text
Crawler / Indexer
    ↓
Index Engine
    ↓
Query Engine
    ↓
Ranking Engine
    ↓
Security Filter
    ↓
Results
```

---

## Search Scope

Tudo que pode ser buscado:

```text
Pessoas (usuários, contatos, clientes)
Documentos (arquivos, wikis, manuais)
CRM (leads, clientes, contratos, oportunidades)
SAC (tickets, chamados, soluções)
Produtos (catálogo, estoque, preços)
Treinamentos (cursos, certificados, trilhas)
Posts (feed, communidades, comentários)
Chats (mensagens, menções)
Tickets (GLPI)
Eventos (reuniões, treinamentos, lives)
Apps (navegação, actions)
Conhecimento (base de conhecimento, FAQ)
Políticas (documentos corporativos)
```

---

## Search Experience

### Google Corporativo

```text
Single search bar
Auto-complete
Search suggestions
Did you mean
Filters
Sort options
Faceted navigation
Saved searches
Recent searches
Search history
```

### Result Types

```text
People: perfil, contato, status
Document: título, tipo, data, autor
Ticket: código, status, prioridade
Course: nome, categoria, progresso
Post: autor, data, curtidas
Chat: conversa, participantes
Event: título, data, participantes
App: nome, descrição, rota
```

### Rich Results

```text
Preview inline
Quick actions
Direct links
Related results
People also search
```

---

## Indexing

### Full-Text Index

```text
Título
Conteúdo completo
Metadados
Tags
Hashtags
Menções
Comentários
Anexos (nome + conteúdo extraído)
```

### Vector Index

```text
Embeddings de conteúdo
Semantic search
Similar documents
Related content
```

### Structured Index

```text
Fields indexados
Filters aplicáveis
Sortable fields
Aggregations
```

---

## Ranking

### Ranking Factors

```text
Relevance (text match)
Freshness (data recência)
Popularity (views, cliques)
User behavior (click-through)
Tenant priority
Contextual boost (app, perfil)
Personalization (histórico do usuário)
Authority (document owner trust)
```

### Ranking Model

```text
BM25 (text relevance)
Learning-to-rank (ML)
Personalization signals
Business rules
Tenant weighting
Freshness decay
```

---

## Security Filter

### Per-Query Security

```text
User permissions
Tenant isolation
Document classification
App permissions
Contextual filters
PII masking
Sensitive data redaction
```

### Search-Time Filtering

```text
Query user identity
    ↓
Resolve permissions
    ↓
Apply tenant filter
    ↓
Apply app filter
    ↓
Apply classification filter
    ↓
Filtered results
```

### Prohibited Results

```text
Documentos de outro tenant
Posts de communidades privadas sem acesso
Tickets de outro departamento
Informações sensíveis sem permissão
Dados pessoais sem consentimento
```

---

## Suggestions & Autocomplete

### Suggestions Sources

```text
History pessoal
Trending na empresa
Popular no tenant
Popular no departamento
Recent search
Saved searches
People you know
Frequent actions
```

### Autocomplete Types

```text
People names
Document titles
Ticket codes
Course names
App names
Commands (/action)
Hashtags
```

---

## Analytics de Busca

```text
Queries mais comuns
Zero-result queries
Click-through rate
Search-to-action conversion
Time to find
Abandoned searches
Suggestion acceptance rate
Search by app
Search by role
Search by tenant
```

---

## Integration with Other MDs

- **MD-002 (Auth)**: identidade e permissões.
- **MD-003 (Operational Context)**: contexto de busca.
- **MD-010 (Security)**: security filter.
- **MD-014 / MD-019 (App Registry)**: apps indexados.
- **MD-017 (MultiTenant)**: isolamento por tenant.
- **MD-020 (Portal Core)**: search no portal.
- **MD-032 (Unified Communication)**: busca em comunicação.
- **MD-034 (IAM)**: permissões de busca.
- **MD-035 (Security Trust Architecture)**: segurança de dados na busca.
- **MD-051 (Data Lake)**: fonte de dados para indexação.

---

## Próximo MD recomendado

```text
MD-054 — Knowledge Graph
```

Grafo de conhecimento.

---

## Regras Canônicas

1. Search é único para toda plataforma.
2. Todo conteúdo indexável é indexado.
3. Indexação respeita tenant isolation.
4. Busca respeita permissões do usuário.
5. Resultados são filtrados por contexto.
6. PII é mascarado em resultados.
7. Sensitive content é redacted.
8. Ranking considera relevance + personalization.
9. Search é auditable.
10. Suggestions respeitam privacy.
11. Full-text + vector search combinados.
12. Indexação é incremental.
13. Re-indexação é triggered por eventos.
14. Zero-result queries são monitoradas.
15. Search analytics alimentam IA.
16. Enterprise search é diferente de Google.
17. Context melhora relevance.
18. Apps podem contribuir com conteúdo.
19. External content via Integration Hub.
20. Search é competitivo advantage.

---

## Proibições

São proibidos:

```text
Busca cross-tenant sem permissão
Exposição de PII em resultados
Dados sensíveis sem redaction
Indexação sem consentimento
Busca sem security filter
Ranking manipulável por tenant
Indexação que degrade operacional
Search sem analytics
Provedor de search externo sem avaliação
Dados de IA raw em resultados
```
