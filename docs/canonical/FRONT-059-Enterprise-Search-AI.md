# FRONT-059 — Enterprise Search AI

## Status

Documento Canônico de Frontend.
Define a experiência de Busca Corporativa com IA.

---

## Objetivo

Tornar a busca o ponto de entrada para toda a inteligência da plataforma.

---

## Princípio Fundamental

```text
O usuário não deve precisar saber
em qual App a informação está.

Busca é universal.
Busca é semântica.
Busca é contextual.
```

---

## Componentes

### SearchBar (Global)

```text
Atalho universal: Cmd+K / Ctrl+K
Placeholder dinâmico:
  - "Buscar pacientes..." (HIS)
  - "Buscar clientes..." (CRM)
  - "Buscar documentos..." (Geral)
Ícone de busca
Sugestões em tempo real (dropdown)
Histórico pessoal
Buscas populares (trending)
```

### SearchResults

```text
Resultados agrupados por tipo:
  ├── Pacientes
  │   ├── Nome, CPF, data nascimento
  │   ├── Último atendimento
  │   └── Ação: "Abrir prontuário"
  ├── Clientes
  │   ├── Nome, CNPJ, tipo
  │   ├── Última compra
  │   └── Ação: "Abrir CRM"
  ├── Documentos
  │   ├── Título, tipo, data
  │   ├── Trecho destacado (highlight)
  │   └── Ação: "Abrir documento"
  ├── Chamados
  │   ├── Título, status, prioridade
  │   ├── Abertura
  │   └── Ação: "Abrir chamado"
  ├── Cursos
  │   ├── Título, progresso
  │   └── Ação: "Continuar"
  ├── Posts
  │   ├── Autor, trecho, data
  │   └── Ação: "Ver post"
  ├── Pessoas
  │   ├── Nome, cargo, unidade
  │   └── Ação: "Chat" / "Perfil"
  └── Ações Diretas
      ├── "Nova senha em [Local]"
      ├── "Novo atendimento"
      ├── "Novo chamado"
      └── "Nova proposta"
```

### SearchFilters

```text
Filtros avançados:
  - Por app
  - Por tipo de conteúdo
  - Por período
  - Por unidade/local
  - Por autor
  - Por status
Aplicação em tempo real
Persistência de filtros preferidos
Salvar busca (se útil)
```

### SearchConversational (IA)

```text
Modo conversacional (botão "IA"):
  Usuário: "Quantos pacientes aguardando cardiologia?"
  IA: "17 pacientes aguardando cardiologia
       na Unidade São Lucas.
       Quer ver a fila?"
  Ações: [Abrir fila] [Ver detalhes] [Exportar]

  Usuário: "Chamados críticos abertos hoje"
  IA: "7 chamados críticos abertos hoje.
       3 em TI, 2 em Infra, 2 em SAC.
       Quer filtrar por área?"
  Ações: [Ver todos] [Filtrar por TI] [Filtrar por Infra]

Recursos:
  - Memória de contexto (sessão)
  - Citação de fontes
  - Ações sugeridas
  - Histórico de conversação
```

### SearchSuggestions

```text
Sugestões ao digitar:
  - Buscas recentes (usuário)
  - Buscas populares (plataforma)
  - Apps usadas pelo usuário
  - Contexto atual (unidade, perfil)
  - Sinônimos mapeados
Sugestão por contexto:
  - Farmácia: "lote 1234" → busca em medicamentos
  - RH: "férias João" → busca em formulários
  - Financeiro: "fatura 2024" → busca em notas fiscais
```

---

## Regras

### Permissões

```text
Busca NUNCA retorna conteúdo sem permissão.
Resultados filtrados por:
  - Tenant
  - Unidade
  - Local
  - Perfil
  - App
Usuário NÃO vê dados de outros tenants.
Usuário NÃO vê documentos sem permissão de leitura.
Nenhuma busca permite cruzar tenants.
Auditoria de toda busca (quem, quando, o quê).
```

### Performance

```text
Sugestões: P95 < 200ms
Busca simples: P95 < 300ms
Busca com filtros: P95 < 500ms
Busca semântica (IA): P95 < 1500ms
Indexação: máximo 5 min de latência
Cache: resultados populares por 10 min
```

### Privacidade

```text
Histórico de busca é privado (por usuário).
Usuário pode limpar histórico.
Histórico NÃO é compartilhado.
Busca em conteúdo sensível é auditada.
Admin NÃO pode ver buscas de outros usuários (apenas agregados).
```

---

## Integrações

| MD / FRONT | Finalidade |
|-----------|-----------|
| MD-053 — Enterprise Search | Documento canônico |
| MD-087 — Enterprise Search Platform | Plataforma de busca |
| MD-084 — Knowledge Graph | Conhecimento conectado |
| MD-081 — AI Copilot | Busca conversacional |
| MD-110 — Canonical Laws | Leis supremas |
| FRONT-003 — Portal | SearchBar no header |
| FRONT-014 — Global Search | Base de busca global |
| FRONT-051 a FRONT-058 | Entidades buscáveis |

---

## Responsabilidades

| Camada | Responsabilidade |
|--------|------------------|
| Frontend | SearchBar, Results, Filters, Conversacional, Suggestions |
| Backend | APIs de busca, sugestões, trending, histórico |
| Dispatcher | Roteamento para Search Engine |
| SP | Consultas de busca, filtros, permissões |
| Event Store | Registrar busca, clique, conversão |
| Search Engine | Indexação, ranking, semântica |
| Knowledge Graph | Entidades, relações, sugestões |
| IA | Busca semântica, conversacional, respostas, síntese |

---

## Métricas

```text
Buscas por dia
Buscas por usuário/dia
Zero-result rate
Tempo até primeiro resultado (P95)
Taxa de clique em resultado
Taxa de ação direta (abrir, criar)
Buscas com filtro vs. sem filtro
Buscas conversacionais (IA)
Sugestões aceitas
Busca por tipo de conteúdo
Satisfação com busca (CSAT)
```

---

## Lei

```text
O usuário não deve precisar saber
em qual App a informação está.
Busca é a porta de entrada
para toda a inteligência da plataforma.
Sem busca, conhecimento está preso.
```

---

## Próximo

```text
FRONT-059 completo
  ↓
FRONT-060 — Predictive Workspace
```
