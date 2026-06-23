# FRONT-006 — Social Experience

## Status

Documento Canônico de Frontend.
Define a experiência de Rede Social Corporativa da plataforma.

---

## Objetivo

Criar um ambiente de colaboração, comunicação e cultura organizacional integrado ao Portal.

---

## Princípio Fundamental

```text
Social não é app separada.
Social é camada de colaboração do Portal.
Feed, chat, comunidades e eventos
nascem dentro da experiência única.
```

---

## Fluxo Canônico

```
Portal (FRONT-003)
  ↓
Feed Social (sidebar/widget)
  ↓
Post
  ↓
Interação (curtir, comentar, compartilhar)
  ↓
Notificação (FRONT-003 / FRONT-004)
  ↓
Chat (FRONT-008) — se necessário
```

---

## Componentes

### Feed

```text
Timeline de posts
Filtros: Todos, Equipe, Empresa, Comunidades
Ordenação: Recente, Relevante
Tipos de post:
  - Texto
  - Imagem
  - Documento
  - Enquete
  - Evento
  - Reconhecimento (Kudos)
Ações: Curtir, Comentar, Compartilhar, Salvar
```

### PostComposer

```text
Editor rico (Markdown simplificado)
Mencionar usuários (@)
Adicionar hashtag
Anexar documento (do repositório de documentos)
Anexar imagem
Agendar publicação (para admins)
Visibilidade: Público, Equipe, Privado
```

### Comunidades

```text
Criação de comunidades (por gestor)
Membros e moderadores
Feed próprio
Regras da comunidade
Aprovação de entrada (opcional)
```

### Eventos

```text
Calendário integrado
Criação de eventos (presencial/virtual)
Convites
RSVP
Lembrete
Sincronização com calendário externo (Google, Outlook)
```

### Reconhecimento

```text
Kudos / Badges
Categorias: "Ajudou", "Inovou", "Entregou", "Citou valores"
Público ou privado
Pontos para gamificação (integrar com FRONT-003 widgets)
```

### PerfilSocial

```text
Informações profissionais
Cargo, departamento, unidade
Atividades recentes
Conquistas e badges
Contato e links
```

---

## Regras

### Visibilidade

```text
Post institucional = todos os tenants (ou todos do tenant)
Post de equipe = membros da comunidade/equipe
Post privado = usuários mencionados
Documento anexado = respeita permissão do documento
```

### Moderação

```text
Conteúdo reportável
Moderação por administrador de comunidade
Aviso de conteúdo sensível
Bloqueio de usuário por infrações (respeita IAM)
Auditoria de remoção de conteúdo
```

### Notificações

```text
Curtida → notifica autor
Comentário → notifica autor + mencionados
Mencionado → notifica imediatamente
Convite para comunidade → notifica com ação direta
Evento → notifica com RSVP
Respeita preferências de notificação do usuário
```

---

## Integrações

| MD | Finalidade |
|----|-----------|
| MD-028 — Enterprise Social Network | Domínio Social |
| MD-029 — Digital Workplace | Workplace integrado |
| MD-042A — Portal Experience | Social como camada do Portal |
| MD-076 — Loyalty & Rewards | Badges, pontos, gamificação |
| MD-088 — Global Notification Center | Notificações sociais |
| MD-110 — Canonical Laws | Leis supremas |
| FRONT-003 — Portal Enterprise Experience | Feed/widgets no Portal |
| FRONT-008 — Chat Experience | Chat integrado |

---

## Responsabilidades

| Camada | Responsabilidade |
|--------|------------------|
| Frontend | Feed, Post Composer, Comunidades, Eventos, Perfil Social |
| Backend | APIs de posts, interações, comunidades, eventos |
| Dispatcher | Roteamento para SPs de social |
| SP | Regras de visibilidade, moderação, moderação |
| Event Store | Registrar POST_CRIADO, POST_CURTIDO, COMENTARIO_CRIADO, EVENTO_CRIADO |

---

## Métricas

```text
Posts por dia
Interações por post (média)
Usuários ativos no Feed diariamente
Comunidades ativas
Eventos criados vs. presença confirmada
Taxa de moderação
Badges distribuídas
Engagement rate (post views vs. interações)
Satisfação com ambiente social (CSAT)
```

---

## Lei

```text
Social é colaboração.
Social não é ruído.
Social é cultura.
Social nasce dentro do Portal.
```

---

## Próximo

```text
FRONT-006 completo
  ↓
FRONT-007 — Intranet Experience
```
