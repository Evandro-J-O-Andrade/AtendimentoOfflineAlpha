# MAP-017 — Social Domain Architecture

## Status
Documento Canônico de Arquitetura.
Arquitetura do domínio social corporativo.

## Classificação
```text
Tipo: Domain Architecture
Camada: Domínio
Prioridade: Média
Obrigatoriedade: Workplace
```

## Objetivo
Definir a arquitetura completa do Social com bounded contexts, agregados, eventos e regras de negócio.

---

## Leis Canônicas Globais Aplicáveis

### LC-001 — Portal é a Entrada Oficial
```text
Login → Portal → Application Registry → Social → Context Selection → Dashboard
```

### LC-005 — SP First Architecture
```text
Frontend → API → Service → Dispatcher → Stored Procedure → Database
```

### LC-014 — Portal = Hub Corporativo
```text
Social é aplicação, não módulo isolado.
```

---

## Hierarquia de Domínios
```text
Social Domain
├── Post Context
├── Comunidade Context
├── Reconhecimento Context
└── Evento Context
```

---

## Fluxo Social Oficial
```text
Usuário
↓
Postagem
↓
Engajamento
↓
Reconhecimento
↓
Comunidade
```

---

## Bounded Contexts

### Post Context
Responsável por: Post, Autor, Conteúdo, Reações, Comentários
Agregado: Post

### Comunidade Context
Responsável por: Comunidade, Membros, Moderadores, Regras, Posts
Agregado: Comunidade

### Reconhecimento Context
Responsável por: Reconhecimento, Destinatário, Remetente, Tipo, Visibilidade
Agregado: Reconhecimento

### Evento Context
Responsável por: Evento, Participantes, Inscrições, Presença
Agregado: Evento

---

## Agregados Principais

### Post Aggregate
```text
post_id (PK)
tenant_id (FK)
autor_id (FK)
conteudo
tipo
data_criacao
comentarios_count
reacoes_count
```

### Comunidade Aggregate
```text
comunidade_id (PK)
tenant_id (FK)
nome
descricao
moderadores
membros_count
ativa
criada_em
```

---

## Eventos Oficiais

### PostCriado
Payload: {post_id, autor_id, tipo, tenant_id}

### ComentarioAdicionado
Payload: {comentario_id, post_id, autor_id, conteudo}

### ReacaoAdicionada
Payload: {reacao_id, post_id, usuario_id, tipo}

### ReconhecimentoDado
Payload: {reconhecimento_id, de_id, para_id, tipo}

### UsuarioIngressouComunidade
Payload: {membro_id, comunidade_id, usuario_id}

---

## Stored Procedures

### sp_post_criar
Input: {conteudo, tipo, tenant_id, usuario_id}
Output: {post_id}

### sp_comunidade_criar
Input: {nome, descricao, moderadores}
Output: {comunidade_id}

### sp_reconhecimento_dar
Input: {para_id, tipo, mensagem}
Output: {reconhecimento_id}

### sp_evento_inscrever
Input: {evento_id, usuario_id}
Output: {inscricao_id}

---

## APIs Oficiais

### /api/v1/social/posts
POST - Criar post
GET - Listar posts

### /api/v1/social/comunidades
POST - Criar comunidade

---

## Regras Arquiteturais

### Digital Workplace Rule
Social é parte do Digital Workplace.

### SP First Rule
Toda escrita passa por Stored Procedure.

---

## Integrações
| MAP/MD | Finalidade |
|--------|-----------|
| MAP-005 — Portal | Acesso via Portal |
| MD-028 — Enterprise Social Network | Social patterns |
| FRONT-072 — Corporate Social | UX |
| FRONT-074 — Communities | Communities |