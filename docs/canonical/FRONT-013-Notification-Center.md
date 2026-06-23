# FRONT-013 — Notification Center

## Status

Documento Canônico de Frontend.
Define a experiência de notificações unificadas da plataforma.

---

## Objetivo

Entregar informação relevante no momento certo, pelo canal certo, para a pessoa certa.

---

## Princípio Fundamental

```text
Notificação não é ruído.
Notificação é informação contextual.

Canal certo.
Momento certo.
Pessoa certa.
Prioridade certa.
```

---

## MDs Relacionados

| MD | Finalidade |
|----|-----------|
| MD-088 — Global Notification Center | Centro de notificações canônico |
| MD-110 — Canonical Laws | Leis supremas |
| FRONT-003 — Portal Enterprise Experience | Notificações no Portal |
| FRONT-004 — App Registry Navigation | Navegação e contexto |

---

## Componentes

### NotificationBell (Header)

```text
Ícone de sino no header do Portal
Badge com contador de não lidas
Cor do badge por prioridade:
  - Vermelho: crítica
  - Laranja: alta
  - Azul: normal
  - Cinza: informativa
Hover: preview das 3 últimas notificações
Click: abre NotificationPanel (dropdown full)
```

### NotificationPanel (Dropdown)

```text
Header: "Notificações" + botão "Marcar todas como lidas"
Filtros rápidos:
  - Todas
  - Não lidas
  - Críticas
  - Por app (dropdown)
Lista agrupada por data:
  - Agora
  - Hoje
  - Ontem
  - Esta semana
  - Anteriores
Cada item:
  - Ícone por tipo
  - Título (bold)
  - Descrição (truncada)
  - Timestamp relativo
  - Badge de app origem
  - Ação direta (se houver)
  - Checkbox de lida (individual)
Footer: "Ver todas" → abre NotificationPage
```

### NotificationPage (Full)

```text
Lista completa de notificações
Filtros laterais:
  - Por app
  - Por tipo
  - Por prioridade
  - Por status (lida/não lida)
  - Por período
Ações em lote:
  - Marcar como lida
  - Arquivar
  - Excluir
Ações individuais:
  - Abrir (navega para app)
  - Marcar como lida
  - Arquivar
  - Exibir detalhes
Configurações (link para preferências)
```

### NotificationPreferences

```text
Canais disponíveis:
  - In-App (Portal)
  - Email
  - SMS
  - WhatsApp
  - Push (Mobile)
Configuração por tipo:
  - Crítica: todos os canais
  - Alta: in-app + email
  - Normal: in-app
  - Informativa: in-app (opcional silenciar)
Quiet hours:
  - Início: 22:00
  - Fim: 08:00
  - Silenciar notificações não críticas
Por app:
  - Habilitar/desabilitar por app
  - Escolher canal preferido por app
```

### InAppToast

```text
Notificação toast (canto inferior direito)
Tipos: success, error, warning, info, notification
Duração: 4s padrão, 8s para crítica
Ação primária (botão)
Ação secundária ("fechar")
Pausa ao hover
Fila: máximo 3 toasts visíveis
Empilhamento vertical
Fechamento automático + botão fechar
```

---

## Tipos de Notificação

| Tipo | Prioridade | Canais | Som |
|------|-----------|--------|-----|
| CRITICA | P1 | Todos | Sim, repetido |
| ALTA | P2 | In-app + Email + Push | Sim |
| NORMAL | P3 | In-app + Push | Não |
| INFORMATIVA | P4 | In-app (opcional silenciar) | Não |
| MARKETING | P5 | Apenas se opt-in | Não |

---

## Canais de Entrega

### In-App (Portal)

```text
NotificationBell + badge
NotificationPanel (dropdown)
NotificationPage (full)
InAppToast (toast)
Tudo em tempo real (WebSocket/SSE)
```

### Email

```text
Template HTML responsivo
Logo e branding do tenant
Conteúdo resumido + link para ação
Unsubscribe (apenas marketing/informativa)
Falha → retry + fallback para in-app
```

### SMS

```text
Apenas P1 e P2 (crítica e alta)
Limite de 160 caracteres
Link de ação encurtado
Opt-out respeitado
```

### WhatsApp

```text
Apenas P1 e P2
Template aprovado
Botão de resposta (se suportado)
Opt-out respeitado
```

### Push (Mobile)

```text
Notificação nativa do sistema
Deep link para tela específica
Ação direta (abrir, responder, aprovar)
Badge no ícone
Prioridade alta (Android) / APNs (iOS)
```

---

## Agrupamento Inteligente

```text
Notificações da mesma app em 5min → agrupadas
  Ex: "3 novos tickets no SAC" (ao invés de 3 toasts)
Notificações relacionadas → thread
  Ex: Respostas em comentário
Notificações de sistema → sempre separadas
Notificações de marketing → sempre separadas
Usuário pode desagrupar (preferência)
```

---

## Estados

### Vazio

```text
Ilustração amigável
"Mensagem: Nenhuma notificação no momento"
Ação: "Explorar apps" ou "Atualizar"
```

### Loading

```text
Skeleton: 3-5 itens com pulse
Pull-to-refresh disponível
```

### Error

```text
"Não foi possível carregar"
Botão: "Tentar novamente"
Cache: mostrar últimas notificações cached (se houver)
```

---

## Integrações

| MD / FRONT | Finalidade |
|-----------|-----------|
| MD-088 — Global Notification Center | Motor de notificações |
| MD-110 — Canonical Laws | Leis supremas |
| FRONT-003 — Portal Enterprise Experience | NotificationBell no header |
| FRONT-010 — Mobile PWA Experience | Push notifications |
| FRONT-004 — App Registry Navigation | Notificações por app |

---

## Responsabilidades

| Camada | Responsabilidade |
|--------|------------------|
| Frontend | NotificationBell, Panel, Page, Preferences, Toast |
| Backend | APIs de notificações, preferências, envio multi-canal |
| Dispatcher | Roteamento para SPs de notificação |
| SP | Regras de agrupamento, preferências, entrega |
| Event Store | Registrar notificação criada, lida, arquivada, enviada |

---

## Métricas

```text
Notificações enviadas por dia
Taxa de entrega por canal
Taxa de abertura (in-app)
Taxa de clique
Taxa de conversão (ação tomada)
Taxa de silenciamento
Taxa de agrupamento
Tempo até abertura
Notificações arquivadas sem leitura
Satisfação com notificações (CSAT)
```

---

## Lei

```text
Notificação não é interrupção.
Notificação é informação relevante
entregue no momento certo,
pelo canal certo,
para a pessoa certa.
```

---

## Próximo

```text
FRONT-013 completo
  ↓
FRONT-014 — Global Search
```
