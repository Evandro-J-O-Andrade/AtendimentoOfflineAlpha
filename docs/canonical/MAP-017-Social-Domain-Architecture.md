# MAP-017 — Social Domain Architecture

## Status
Documento Canônica de Arquitetura.
Arquitetura do domínio social corporativo.

---

## Classificação
```text
Tipo: Domain Architecture
Camada: Domínio
Prioridade: Média
Obrigatoriedade: Workplace
```

---

## Objetivo
Definir arquitetura de comunidades, engajamento e colaboração.

---

## Bounded Contexts

### Post Context
```text
Post
Autor
Conteúdo
Reações
Comentários
```

### Comunidade Context
```text
Comunidade
Membros
Moderadores
Regras
Posts
```

### Reconhecimento Context
```text
Reconhecimento
Destinatário
Remetente
Tipo
Visibilidade
```

### Evento Context
```text
Evento
Participantes
Inscrições
Presença
```

---

## Agregados

### Post Aggregate
```text
post_id
tenant_id
autor_id
conteudo
tipo
data_criacao
```

### Comunidade Aggregate
```text
comunidade_id
tenant_id
nome
descricao
moderadores
membros_count
```

---

## Eventos Oficiais

### PostCriado
### ComentarioAdicionado
### ReacaoAdicionada
### ReconhecimentoDado
### UsuarioIngressouComunidade

---

## Integrações
| MAP/MD | Finalidade |
|--------|-----------|
| MAP-001 — Enterprise Domain | Foundation |
| MD-028 — Enterprise Social Network | Social |
| FRONT-072 — Corporate Social | UX |
| FRONT-074 — Communities | Communities |