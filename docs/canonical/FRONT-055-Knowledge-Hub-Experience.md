# FRONT-055 — Knowledge Hub Experience

## Status

Documento Canônico de Frontend.
Define a experiência do Hub de Conhecimento Corporativo.

---

## Objetivo

Centralizar todo o conhecimento da organização em um lugar único, inteligente e acessível.

---

## Princípio Fundamental

```text
Conhecimento corporativo
não deve estar espalhado.
Conhecimento deve ser:
  Encontrado
  Consumido
  Colaborado
  Evoluído
```

---

## Componentes

### KnowledgeBase

```text
Repositório central:
  - Documentos (PDF, DOCX, XLSX, PPT)
  - Políticas e procedimentos (POPs)
  - Normativas (ANVISA, CFM, LGPD, ISO)
  - Treinamentos (AVA)
  - Wiki corporativa
  - Manuais
  - Templates
  - Modelos
Organização:
  - Categorias hierárquicas
  - Tags semânticas
  - Coleções curadas
  - Conteúdo por contexto (unidade, perfil)
```

### BuscaInteligente

```text
Busca semântica (IA):
  - "política de férias" → encontra documento correto
  - "protocolo de dor torácica" → encontra POP
  - "LGPD para pacientes" → encontra normativa
Filtros:
  - Por tipo (documento, política, curso, post)
  - Por categoria
  - Por data
  - Por autor
  - Por relevância
Resultados com:
  - Preview do documento
  - Trecho destacado
  - Data de atualização
  - Autor
  - Curtidas/visualizações (social proof)
```

### Colaboracao

```text
Comentários por documento
Avaliações (útil, desatualizado, incorreto)
Sugestões de edição (versão proposta)
Versionamento:
  - Histórico completo
  - Comparação entre versões
  - Rollback (com aprovação)
  - Notificação de atualização
```

### Curadoria

```text
Editores por categoria:
  - Aprovam conteúdo
  - Atualizam
  - Marcam como obsoleto
  - Definem visibilidade
Workflow de publicação:
  - Rascunho
  - Revisão
  - Aprovação
  - Publicação
  - Arquivamento
```

### IA Knowledge

```text
Resumo automático de documentos
Extração de tópicos
Recomendação de leitura relacionada
Detecção de conteúdo desatualizado
Classificação automática por categoria
Resposta a perguntas (Q&A sobre a base)
```

---

## Regras

### Acesso

```text
Documento público: todos os tenants (ou todos de um tenant)
Documento interno: apenas colaboradores do tenant
Documento restrito: por perfil/unidade
Documento confidencial: aprovadores + destinatários
Log de acesso: tudo é auditado
```

### Publicação

```text
Nenhum documento é publicado sem curadoria.
Políticas corporativas requerem aprovação de diretoria.
Documentos legais requerem validação de compliance.
Templates são aprovados por área de negócio.
```

### Manutenção

```text
Revisão periódica obrigatória (ex: anualmente).
Owner responsável por cada documento.
Notificação de revisão pendente.
Arquivamento automático de versões antigas.
Lembrete de atualização.
```

---

## Integrações

| MD / FRONT | Finalidade |
|-----------|-----------|
| MD-034 — IAM | Permissões de acesso |
| MD-088 — Global Notification Center | Notificações de atualização |
| MD-087 — Enterprise Search | Busca corporativa |
| MD-084 — Knowledge Graph | Conhecimento conectado |
| MD-081 — AI Copilot | Q&A, resumos |
| FRONT-007 — Intranet Experience | Comunicados, políticas |
| FRONT-009 — AVA Experience | Treinamentos |
| FRONT-014 — Global Search | Busca unificada |

---

## Responsabilidades

| Camada | Responsabilidade |
|--------|------------------|
| Frontend | KnowledgeBase, BuscaInteligente, Colaboracao, Curadoria |
| Backend | APIs de documentos, busca, versionamento |
| Dispatcher | Roteamento para SPs de documentos |
| SP | Regras de acesso, versionamento, aprovação |
| Event Store | Registrar acesso, visualização, edição |
| IA | Resumos, classificação, Q&A, recomendação |

---

## Métricas

```text
Documentos na base
Documentos atualizados no último mês
Buscas por dia
Taxa de sucesso de busca (não vazio)
Documentos mais acessados
Colaboradores editando/cuidando
Taxa de documentos desatualizados (alerta)
Satisfação com busca (CSAT)
Tempo para encontrar documento
```

---

## Lei

```text
Conhecimento corporativo
deve ser encontrável, consumível e evoluível.
Sem conhecimento compartilhado,
não existe inteligência coletiva.
```

---

## Próximo

```text
FRONT-055 completo
  ↓
FRONT-056 — Digital Twin Experience
```
