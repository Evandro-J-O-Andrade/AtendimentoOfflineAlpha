# FRONT-057 — Smart Notification Experience

## Status

Documento Canônico de Frontend.
Define a experiência de notificações inteligentes da plataforma.

---

## Objetivo

Entregar informação contextual, priorizada e acionável no momento certo.

---

## Princípio Fundamental

```text
Notificação não é alerta.
Notificação é insight.

Nem toda informação precisa ser imediata.
Nem toda informação precisa de ação.
Mas quando precisar,
o usuário deve estar preparado.
```

---

## Componentes

### SmartInbox

```text
Inbox unificado (todas as apps)
Classificação automática por IA:
  - Crítica (ação imediata)
  - Alta (ação no dia)
  - Normal (leitura recomendada)
  - Informativa (consulta opcional)
Agrupamento inteligente:
  - Por projeto
  - Por tema
  - Por urgência
  - Por contexto
Priorização:
  - Baseada em perfil
  - Baseada em histórico de ação
  - Baseada em deadline
```

### NudgeEngine

```text
Nudges sutis (IA):
  - "Você tem 3 aprovações pendentes"
  - "Meta semanal 80% concluída (faltam R$ 4.200)"
  - "Paciente X aguardando há 2h na fila"
  - "Estoque Y chegando ao mínimo"
  - "Contrato Z vence em 3 dias"
  - "Treinamento LGPD expira em 7 dias"
Tipos:
  - Banner (topo da tela)
  - Toast (canto)
  - Badge (ícone)
  - Sombra (sidebar)
```

### DigestMode

```text
Resumo inteligente por período:
  - "Seu dia" (manhã)
  - "Sua semana" (segunda-feira)
Conteúdo:
  - Pendências acumuladas
  - Aprovações pendentes
  - Alertas resolvidos
  - Novos eventos relevantes
Ações diretas no digest:
  - Aprovar
  - Adiar
  - Arquivar em lote
```

### PriorityMatrix

```text
Matriz 2x2 automática:
  Importante / Urgente
  Importante / Não urgente
  Não importante / Urgente
  Não importante / Não urgente
IA classifica baseada em:
  - Deadline
  - Impacto financeiro
  - Impacto operacional
  - Impacto em pessoas
```

### QuietHours

```text
Respeita horário do usuário.
Notificações não críticas silenciadas.
Emergencias sempre passam (com justificativa).
Configurável por:
  - Usuário
  - App
  - Tipo
  - Tenant
Override para plantões/exceções.
```

---

## Regras

### IA Priorização

```text
Modelo aprende com comportamento do usuário:
  - Quais notificações ele abre primeiro
  - Quais ele ignora
  - Quais ele marca como lida sem ler
  - Em quais horários ele está mais ativo
Ajusta ranking automaticamente.
Usuário pode dar feedback (útil / irrelevante).
```

### Canais Inteligentes

```text
Crítica → In-app + Push + SMS + Email
Alta → In-app + Email
Normal → In-app + Digest
Informativa → Apenas Digest
Marketing → Apenas se opt-in
```

### Saturação Anti-Ruído

```text
Máximo 3 toasts visíveis simultaneamente.
Máximo 10 notificações por dia por app (anti-spam).
Agrupamento automático de notificações similares.
Silenciamento automático de apps sem interação há 7 dias (com aviso).
```

---

## Integrações

| MD / FRONT | Finalidade |
|-----------|-----------|
| MD-088 — Global Notification Center | Motor de notificações |
| MD-081 — AI Copilot | IA de priorização |
| MD-110 — Canonical Laws | Leis supremas |
| FRONT-013 — Notification Center | Base de notificações |
| FRONT-014 — Global Search | Busca em notificações |
| FRONT-010 — Mobile PWA | Push notifications |

---

## Responsabilidades

| Camada | Responsabilidade |
|--------|------------------|
| Frontend | SmartInbox, NudgeEngine, DigestMode, PriorityMatrix, QuietHours |
| Backend | APIs de notificações, IA de classificação |
| Dispatcher | Roteamento para SPs e IA |
| SP | Regras de priorização, agrupamento |
| Event Store | Registrar visualização, ação, feedback |
| IA | Classificação, priorização, resumo, nudge |

---

## Métricas

```text
Notificações enviadas por dia
Taxa de abertura por prioridade
Taxa de ação (clique) por prioridade
Taxa de silenciamento
Taxa de feedback "útil" vs. "irrelevante"
Tempo médio até ação
Saturação (usuários com > 10/dia)
Satisfação com notificações (CSAT)
Redução de ruído após implementação de IA (%)
```

---

## Lei

```text
Notificação não é alerta.
Notificação é insight.
Smart Notification antecipa necessidades.
Usuário não precisa caçar informação.
Informação chega no momento certo.
```

---

## Próximo

```text
FRONT-057 completo
  ↓
FRONT-058 — Universal Timeline Experience
```
