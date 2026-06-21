# MD-029 — Digital Workplace & Collaboration Platform

## Status

Documento Canônico da Plataforma de Trabalho Digital Corporativo da Plataforma Enterprise.

---

## Objetivo

Transformar o Portal Core em um ambiente completo de trabalho digital.

Não apenas um launcher de aplicações.

Mas o local onde o colaborador trabalha diariamente.

---

## Lei Fundamental

```text
O Portal não é apenas um menu.

O Portal é o ambiente de trabalho oficial do usuário.
```

---

## Posicionamento Canônico

```text
Portal Core
├── App Registry
├── Analytics
├── Social Network
├── Chat
├── Intranet
├── Calendário
├── Eventos
├── ITSM / GLPI
├── AVA
├── Wiki
└── IA
```

---

## Blocos Principais

### Intranet Corporativa

Central de comunicação.

Contém:

```text
Notícias
Comunicados
Avisos
Políticas
Documentos
Normativas
Procedimentos
```

### Lei da Intranet

```text
Todo conteúdo da Intranet é um evento.

Todo conteúdo é versionado.

Todo conteúdo é auditável.

Todo conteúdo respeita tenant.
```

---

### Enterprise Social Network

Estilo:

```text
Facebook
LinkedIn
Workplace
Yammer
```

Recursos:

```text
Feed
Curtidas
Comentários
Compartilhamentos
Hashtags
Menções
Stories Corporativos
Enquetes
Vídeos
```

Integra com:

```text
IA
AVA
CRM
ITSM
```

---

### Chat Corporativo

Estilo:

```text
Teams
Slack
Discord
WhatsApp
```

Suporta:

```text
Chat privado
Chat em grupo
Canais
Mensagens de voz
Vídeo chamadas
Compartilhamento de arquivos
Integração com IA
Integração com Aplicativos
```

### Integrações do Chat

```text
Cross-App
Cross-Tenant (conforme permissão)
Context-Aware
Context-Transfer
```

---

### Comunidades

Exemplos:

```text
TI
RH
Financeiro
Comercial
Operacional
Farmácia
Enfermagem
Médicos
Clientes
Parceiros
Fornecedores
```

---

### Chamados (GLPI Enterprise)

Plataforma ITSM completa.

Inspirada em:

GLPI

Módulos:

```text
Incidentes
Problemas
Mudanças
Catálogo de Serviços
CMDB
Ativos
Inventário
Help Desk
SLA
Base de Conhecimento
```

Apps:

```text
SERVICE_DESK
ITSM
CMDB
ASSET_MANAGEMENT
```

### Modelo Canônico de Chamado

```json
{
  "codigo": "CHAMADO_001",
  "tipo": "INCIDENTE",
  "categoria": "HARDWARE",
  "prioridade": "ALTA",
  "status": "ABERTO",
  "solicitante_id": "UUID",
  "responsavel_id": "UUID",
  "tenant_id": 0,
  "unidade_id": 0,
  "local_id": 0,
  "ia_assistente": "SUPORTE_IA",
  "historico": [],
  "solucao": {},
  "avaliacao": 0,
  "created_at": "datetime",
  "updated_at": "datetime"
}
```

### Regras ITSM

1. Chamado é um evento.
2. Chamado respeita tenant.
3. Chamado respeita contexto.
4. Chamado tem IA associada.
5. Chamado tem SLA.
6. Chamado é auditável.
7. Chamado precisa de avaliação.
8. Chamado integra com Knowledge Hub.
9. Chamado integra com CMDB.
10. Chamado integra com Analytics.

---

### Calendário Global

Estilo:

```text
Google Calendar
Microsoft Outlook
```

Eventos:

```text
Corporativos
Departamentais
Pessoais
Treinamentos
Reuniões
Plantões
Escalas
```

### Modelo Canônico de Evento

```json
{
  "evento_id": "UUID",
  "tipo": "TREINAMENTO",
  "titulo": "Treinamento GLPI",
  "descricao": "Capacitação equipe de TI",
  "inicio": "datetime",
  "fim": "datetime",
  "participantes": [],
  "tenant_id": 0,
  "unidade_id": 0,
  "local_id": 0,
  "ia_participante": "TUTOR_IA",
  "status": "AGENDADO",
  "created_at": "datetime"
}
```

---

### Gestão de Eventos

Portal terá:

```text
Eventos
Congressos
Cursos
Palestras
Lives
Webinars
Treinamentos
```

Integra com:

```text
Social Network
Chat
Calendário
AVA
CRM
```

---

### AVA Integrado

Não apenas cursos.

Também:

```text
Certificados
Trilhas
Gamificação
Ranking
Competências
Mentorias
Comunidades de Aprendizagem
```

Integra com:

```text
Social Network
Wiki
Knowledge Hub
Analytics
IA
```

---

### Wiki Corporativa

Estilo:

```text
Confluence
Notion
MediaWiki
```

Contém:

```text
Documentação
Processos
Procedimentos
FAQs
Manuais
Políticas
Normas
```

### Responsabilidades

```text
Criar página
Editar página
Versionar página
Controlar acesso
Auditar alterações
Indexar para RAG
Compartilhar página
```

---

### Gestão de Conhecimento

Integrado à IA.

Fontes:

```text
Wiki
Documentos
AVA
Chamados
CRM
SAC
Social Network
```

Integra com:

```text
RAG Engine
Knowledge Hub
IA
Analytics
```

---

### Rede Social + IA

Toda comunidade pode possuir:

```text
Moderador IA
Tutor IA
Suporte IA
Especialista IA
```

### IA Contextual

```text
IA analisa engajamento
IA sugere conteúdo
IA modera automaticamente
IA personaliza feed
IA detecta abuso
IA extrai insights
IA gera resumos
IA responde perguntas
IA cria conteúdo
```

---

## Dashboard do Colaborador

Cada usuário possui:

```text
Feed
Agenda
Tarefas
Mensagens
Treinamentos
Chamados
Indicadores
Apps Favoritas
```

### Componentes do Dashboard

```text
SOCIAL_FEED_WIDGET
CALENDAR_WIDGET
TASKS_WIDGET
MESSAGES_WIDGET
LEARNING_WIDGET
TICKETS_WIDGET
METRICS_WIDGET
FAVORITES_WIDGET
```

---

## Estrutura Final do Portal

O Portal deixa de ser apenas:

```text
Portal
↓
Apps
```

e passa a ser:

```text
Portal Core
├── App Registry
├── Analytics
├── Intranet
├── Social Network
├── Chat
├── Calendário
├── Eventos
├── AVA
├── Wiki
├── ITSM / GLPI
├── IA
├── N8N
├── CRM
├── SAC
├── PDV
├── Financeiro
├── Operacional
├── Marketplace
└── Integrações
```

---

## Apps Registradas

```text
DIGITAL_WORKPLACE
SOCIAL_FEED
SOCIAL_COMMUNITIES
SOCIAL_CHAT
SOCIAL_EVENTS
SOCIAL_LIVE
SOCIAL_PODCAST
INTRANET
INTRANET_NOTICIAS
INTRANET_POLICIES
INTRANET_DOCUMENTS
CHAT_CORPORATIVO
CALENDARIO_GLOBAL
EVENTOS_GESTAO
ITSM_GLPI
SERVICE_DESK
CMDB
ASSET_MANAGEMENT
WIKI_CORPORATIVA
KNOWLEDGE_MANAGER
LEARNING_PLATFORM
```

---

## Eventos Canônicos

Todos os eventos do Digital Workplace vão para Event Store.

### Eventos Intranet

```text
INTRANET_NOTICIA_CRIADA
INTRANET_NOTICIA_EDITADA
INTRANET_POLICA_CRIADA
INTRANET_DOCUMENTO_COMPARTILHADO
```

### Eventos Social

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

### Eventos ITSM

```text
CHAMADO_ABERTO
CHAMADO_ATRIBUIDO
CHAMADO_RESOLVIDO
CHAMADO_FECHADO
CHAMADO_REABERTO
CHAMADO_PRIORIDADE_ALTERADA
ATIVO_CRIADO
ATIVO_ALTERADO
ATIVO_REMOVIDO
SLAs_ALERTA
SLAs_VIOLADO
KNOWLEDGE_BASE_USADO
```

### Eventos Wiki

```text
WIKI_PAGINA_CRIADA
WIKI_PAGINA_EDITADA
WIKI_PAGINA_REMOVIDA
WIKI_PAGINA_VERSIONADA
WIKI_PAGINA_COMPARTILHADA
```

### Eventos Calendário

```text
CALENDARIO_EVENTO_CRIADO
CALENDARIO_EVENTO_ATUALIZADO
CALENDARIO_EVENTO_CANCELADO
CALENDARIO_EVENTO_CONVIDADO
CALENDARIO_LEMBRETE_ENVIADO
```

### Eventos AVA

```text
CURSO_INICIADO
CURSO_CONCLUIDO
TRILHA_INICIADA
TRILHA_CONCLUIDA
CERTIFICADO_EMITIDO
MENTORIA_INICIADA
MENTORIA_ENCERRADA
RANKING_ATUALIZADO
```

### Modelo de Evento

```json
{
  "evento_uuid": "UUID",
  "execucao_uuid": "UUID",
  "dominio": "WORKPLACE",
  "acao": "CHAMADO_ABERTO",
  "tenant_id": 0,
  "usuario_id": "UUID",
  "payload": {
    "tipo": "INCIDENTE",
    "categoria": "HARDWARE",
    "prioridade": "ALTA",
    "ia_assistente": "SUPORTE_IA"
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

1. Workplace usa sessão canônica.
2. Workplace usa tenant da sessão.
3. Workplace usa contexto operacional.
4. Workplace usa permissões do IAM.
5. Workplace usa Event Store.
6. Workplace não recebe segredo no frontend.
7. Workplace respeita tenant isolation.
8. Workplace é auditável.
9. Workplace tem rate limiting.
10. Workplace tem detecção de abuso.

---

## Analytics Workplace

Métricas canônicas:

```text
Usuários ativos
Tempo no Portal
Apps usadas
Eventos criados
Chamados abertos
Cursos concluídos
Documentos acessados
Mensagens enviadas
Reuniões agendadas
Engajamento social
```

### Dashboards

```text
WORKPLACE_DASHBOARD_GERAL
SOCIAL_ENGAGEMENT
ITSM_PERFORMANCE
LEARNING_METRICS
WIKI_USAGE
CALENDAR_UTILIZACAO
```

---

## Integração com Outros MDs

- **MD-002 (Auth)**: identidade, sessão, JWT, refresh token e MFA.
- **MD-003 (Operational Context)**: tenant, unidade, local, perfil e contexto operacional.
- **MD-004 (Dispatcher)**: entrada oficial de ações executáveis.
- **MD-005 (Event Store)**: auditoria e histórico de execuções.
- **MD-010 (Security)**: base de segurança.
- **MD-014 / MD-019 (App Registry)**: apps do Workplace registradas no Portal.
- **MD-016 (Auditoria)**: rastreabilidade e imutabilidade.
- **MD-017 (MultiTenant)**: isolamento por tenant.
- **MD-020 (Portal Core Architecture)**: Portal como origem de todas as apps.
- **MD-026 (Security Zero Trust)**: zero trust, webhook signing, sessão e tenant.
- **MD-027 (AI Orchestration Platform)**: IA integrada ao Workplace.
- **MD-028 (Enterprise Social Network)**: rede social corporativa.
- **MD-033 (Analytics Governance)**: métricas do Workplace.
- **MD-034 (Identity Access Management)**: usuários, apps, escopos, perfis dinâmicos e permissões.

---

## Próximo MD recomendado

```text
MD-032 — Unified Communication & Engagement Platform
```

Hub de comunicação unificada.

---

## Regras Canônicas

1. Digital Workplace é o ambiente de trabalho oficial.
2. Portal Core é a origem de todas as apps do Workplace.
3. Nenhuma aplicação implementa Workplace próprio.
4. Todo conteúdo é um evento.
5. Todo conteúdo é auditável.
6. Todo conteúdo respeita tenant isolation.
7. Todo conteúdo respeita Zero Trust.
8. IA integra-se a todos os módulos.
9. ITSM é completo e robusto.
10. Wiki é fonte de conhecimento.
11. Knowledge Hub integra todas as fontes.
12. RAG serve todo o Workplace.
13. Calendário é global e integrado.
14. Eventos são socialmente conectados.
15. AVA é socialmente conectado.
16. Dashboard é central e personalizável.
17. Apps são registradas no App Registry.
18. Permissões são declaradas explicitamente.
19. Métricas alimentam Analytics.
20. Event Store registra tudo.