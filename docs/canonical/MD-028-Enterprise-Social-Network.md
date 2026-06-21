# MD-028 — Enterprise Social Network

## Status

Documento Canônico da Plataforma de Rede Social Corporativa da Plataforma Enterprise.

---

## Objetivo

Criar a camada social corporativa da plataforma integrada ao Portal Core.

Não é uma rede social pública.

É uma rede social enterprise canônica, contextual e auditável.

---

## Lei Fundamental

```text
Toda pessoa da plataforma pode colaborar.

Toda colaboração é contextual.

Toda interação é auditável.
```

---

## Posicionamento Canônico

```text
Portal Core
├── App Registry
├── Analytics
├── Social Network
└── IA
```

A colaboração é um serviço transversal da plataforma.

---

## Lei Canônica

```text
A colaboração é um serviço transversal da plataforma.

Nenhuma aplicação implementa sua própria rede social.

Toda colaboração pertence ao Enterprise Social Network.
```

---

## Domínios

```text
Feed Corporativo
Comunidades
Mensagens
Chat
Canais
Reações
Comentários
Eventos
Lives
Podcast
Notificações
```

---

## Feed Corporativo

Semelhante a:

```text
LinkedIn
Workplace
Teams Feed
```

Permite:

```text
Comunicados
Postagens
Arquivos
Vídeos
Enquetes
Avisos
```

### Lei do Feed

```text
Todo post no Feed é um evento no Event Store.

Todo post respeita tenant.

Todo post respeita contexto operacional.

Todo post é auditável.

Todo post pode ter IA moderando.
```

---

## Comunidades

Exemplos:

```text
TI
Comercial
Financeiro
RH
Operacional
Clientes
Parceiros
Farmácia
Enfermagem
Médicos
```

Cada tenant pode criar comunidades.

### Responsabilidades

```text
Criar comunidade
Editar comunidade
Definir membros
Definir moderadores
Definir IA associada
Definir regras
Definir visibilidade
Definir tenant
Definir escopo
```

### Modelo Canônico de Comunidade

```json
{
  "codigo": "TI",
  "nome": "Tecnologia da Informação",
  "tenant": "GLOBAL",
  "categoria": "INTERNO",
  "visibilidade": "TENANT_ONLY",
  "membros": [],
  "moderadores": [],
  "ia_moderador": "MODERADOR_IA",
  "ia_assistente": "ASSISTENTE_IA",
  "status": "ACTIVE",
  "created_at": "datetime",
  "updated_at": "datetime"
}
```

### Regras

1. Comunidade precisa estar registrada.
2. Comunidade precisa de tenant.
3. Comunidade precisa de owner.
4. Comunidade precisa de IA moderadora.
5. Comunidade precisa de regras.
6. Comunidade precisa de membros.
7. Comunidade respeita tenant isolation.
8. Comunidade respeita permissões.
9. Comunidade gera eventos.
10. Comunidade é auditável.

---

## Chat Corporativo

Estilo:

```text
Teams
Slack
Discord
WhatsApp
```

Suporta:

```text
1x1
Grupo
Canal
Tenant
Cross-App
```

### Responsabilidades

```text
Chat privado
Chat em grupo
Canais
Compartilhamento de arquivos
Mensagens de voz
Vídeo chamadas
```

---

## Reações

Tipos:

```text
LIKE
CELEBRATE
SUPPORT
INSIGHTFUL
CURIOUS
```

### Lei das Reações

```text
Toda reação é um evento.

Toda reação é auditável.

Toda reação respeita tenant.

Toda reação respeita contexto.
```

---

## Comentários

### Responsabilidades

```text
Criar comentário
Editar comentário
Remover comentário
Responder comentário
Mencionar usuário
Mencionar IA
Incluir arquivos
Incluir RAG
```

### Regras

1. Comentário é um evento.
2. Comentário respeita tenant.
3. Comentário respeita contexto.
4. Comentário é auditável.
5. Comentário pode ter IA moderando.
6. Comentário pode referenciar RAG.
7. Comentário precisa de menção válida.
8. Comentário gera evento de menção.
9. Comentário respeita permissões.
10. Comentário é versionado.

---

## Integração com IA

Toda comunidade pode possuir:

```text
Assistente IA
Moderador IA
Tutor IA
Analista IA
```

### Agentes IA para Social

```text
MODERADOR_IA
ASSISTENTE_IA
TUTOR_IA
ANALISTA_IA
```

### Regras de IA Social

1. IA só atua onde está registrada.
2. IA respeita regras da comunidade.
3. IA gera evento de ação.
4. IA é configurável por tenant.
5. IA não executa ação sem permissão.
6. IA não acessa fora do tenant.
7. IA registra decisões.
8. IA é observável.
9. IA precisa de owner.
10. IA precisa de versão.

---

## Integração com AVA

Permite:

```text
Discussão de cursos
Comunidades de aprendizagem
Mentorias
Trilhas colaborativas
```

### Comunidades AVA

```text
CURSO_DISCUSSAO
MENTORIA
TRILHA_COLABORATIVA
CERTIFICADO
RANKING
```

---

## Integração com CRM

Permite:

```text
Comunidades de clientes
Comunidades de parceiros
Comunidades de fornecedores
```

### Comunidades CRM

```text
CLIENTE
PARCEIRO
FORNECEDOR
COMUNIDADE_EXTERNA
```

---

## Eventos Canônicos

Todos os eventos da social network vão para Event Store.

### Eventos mínimos

```text
POST_CRIADO
POST_EDITADO
POST_REMOVIDO

COMENTARIO_CRIADO
COMENTARIO_EDITADO

REACAO_ADICIONADA

COMUNIDADE_CRIADA

CANAL_CRIADO

MENSAGEM_ENVIADA
```

### Eventos complementares

```text
MENCAO_CRIADA
MENCAO_REMOVIDA

DOCUMENTO_COMPARTILHADO

VIDEO_COMPARTILHADO

ENQUIPE_CRIADA
ENQUETE_RESPONDIDA

LIVE_INICIADA
LIVE_FINALIZADA

PODCAST_POSTADO
PODCAST_REMOVIDO
```

### Modelo de Evento

```json
{
  "evento_uuid": "UUID",
  "execucao_uuid": "UUID",
  "dominio": "SOCIAL",
  "acao": "POST_CRIADO",
  "tenant_id": 0,
  "usuario_id": "UUID",
  "comunidade_id": "UUID",
  "payload": {
    "tipo": "COMUNICADO",
    "conteudo": {},
    "arquivos": []
  },
  "resultado": {},
  "timestamp": "datetime"
}
```

---

## Segurança

Herda:

```text
JWT
HttpOnly
Refresh Token
MFA
Google Authenticator
Audit Trail
Tenant Isolation
Zero Trust
Webhook Signing
```

### Regras de Segurança

1. Social usa sessão canônica.
2. Social usa tenant da sessão.
3. Social usa contexto operacional.
4. Social usa permissões do IAM.
5. Social usa Event Store.
6. Social não recebe segredo no frontend.
7. Social respeita tenant isolation.
8. Social é auditável.
9. Social tem rate limiting.
10. Social tem detecção de abuso.

---

## Apps Registradas

```text
SOCIAL_FEED
SOCIAL_COMMUNITIES
SOCIAL_CHAT
SOCIAL_EVENTS
SOCIAL_LIVE
SOCIAL_PODCAST
```

### Modelo Canônico de App

```json
{
  "codigo": "SOCIAL_FEED",
  "nome": "Feed Corporativo",
  "dominio": "SOCIAL",
  "rota": "/apps/social/feed",
  "contexto_obrigatorio": false,
  "auth_required": true,
  "permissoes": [
    "SOCIAL_FEED.ACESSAR",
    "POST.CRIAR",
    "POST.EDITAR",
    "POST.REMOVER"
  ],
  "sp_namespace": "SOCIAL",
  "event_namespace": "SOCIAL",
  "dashboards": [
    "SOCIAL_ANALYTICS_GERAL",
    "SOCIAL_ENGAGEMENT"
  ],
  "entrypoints": [
    "UI",
    "API",
    "DISPATCHER"
  ],
  "tenant_scope": "MULTI_TENANT"
}
```

---

## Integração com o Portal

No App Registry:

```text
SOCIAL_FEED
SOCIAL_COMMUNITIES
SOCIAL_CHAT
SOCIAL_EVENTS
SOCIAL_LIVE
SOCIAL_PODCAST
```

Tudo nasce dentro do Portal Core.

### Fluxo de Integração

```text
Usuário
↓
Portal Core
↓
App de Social
↓
Sessão
↓
Tenant
↓
Contexto
↓
Permissão
↓
Social Engine
↓
Event Store
```

---

## Analytics Social

Métricas canônicas:

```text
Posts criados
Comentários criados
Reações dadas
Mensagens enviadas
Comunidades criadas
Canais criados
Usuários ativos
Engagement rate
Tempo no feed
```

---

## Integração com Outros MDs

- **MD-002 (Auth)**: identidade, sessão, JWT, refresh token e MFA.
- **MD-003 (Operational Context)**: tenant, unidade, local, perfil e contexto operacional.
- **MD-004 (Dispatcher)**: entrada oficial de ações executáveis.
- **MD-005 (Event Store)**: auditoria e histórico de execuções.
- **MD-010 (Security)**: base de segurança.
- **MD-014 / MD-019 (App Registry)**: apps de Social registradas no Portal.
- **MD-016 (Auditoria)**: rastreabilidade e imutabilidade.
- **MD-017 (MultiTenant)**: isolamento por tenant.
- **MD-020 (Portal Core Architecture)**: Portal como origem de todas as apps.
- **MD-026 (Security Zero Trust)**: zero trust, webhook signing, sessão e tenant.
- **MD-027 (AI Orchestration Platform)**: IA moderadora e assistente nas comunidades.
- **MD-033 (Analytics Governance)**: métricas de social network.
- **MD-034 (Identity Access Management)**: usuários, apps, escopos, perfis dinâmicos e permissões.

---

## Próximo MD recomendado

```text
MD-032 — Unified Communication & Engagement Platform
```

Hub de comunicação unificada.

Depois segue:

```text
MD-030 — Enterprise Analytics
```

---

## Regras Canônicas

1. Social é serviço transversal da plataforma.
2. Portal Core é a origem de todas as apps de Social.
3. Nenhuma aplicação implementa Social própria.
4. Todo post pertence ao Feed.
5. Todo post é um evento.
6. Todo comentário é um evento.
7. Toda reação é um evento.
8. Toda comunidade é registrada.
9. Toda comunidade pode ter IA.
10. Social respeita tenant isolation.
11. Social respeita Zero Trust.
12. Social respeita Human-in-the-Loop quando aplicável.
13. Social tem owner.
14. Social é versionado.
15. Social é observável.
16. Social é auditável.
17. Social integra com IA.
18. Social integra com AVA.
19. Social integra com CRM.
20. Toda interação gera evento.