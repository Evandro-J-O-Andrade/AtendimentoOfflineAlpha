# MD-042A — Portal Experience & Digital Workplace Architecture

## Status

Emenda Canônica dos MDs:

```text
MD-006 Portal
MD-020 Portal Core Architecture
MD-028 Enterprise Social Network
MD-029 Digital Workplace
MD-041 Design System Enterprise
MD-042 Frontend Shell Architecture
MD-043 Dashboard Framework
MD-034 IAM
```

---

## Objetivo

Definir a experiência do usuário da Plataforma SaaS Enterprise Multi-Tenant.

---

## Lei Fundamental

```text
Portal é a porta de entrada.
Apps executam negócio.
Usuários navegam.
O Portal orquestra.
```

---

## Fluxo Canônico

```text
Login
  ↓
Portal Core
  ↓
App Registry
  ↓
Aplicação
  ↓
Dashboard
  ↓
Contexto Operacional
  ↓
Operação
```

---

## Portal É A Home

### Regra

O Portal é sempre a página inicial.

Nunca:

```text
Intranet
CRM
HIS
PDV
Financeiro
SAC
```

### Sempre

```text
Portal Core
```

---

## Intranet É Uma App

### Regra

A Intranet não é o sistema.
A Intranet é uma App registrada.

### Objetivo

```text
Comunicação institucional
Cultura organizacional
Eventos
Comunicados
Diretoria
Organograma
Notícias
```

---

## AVA É Uma App

Objetivo:

```text
Cursos
Treinamentos
Avaliações
Certificações
Gamificação
```

---

## Documentos É Uma App

Objetivo:

```text
POPs
Normativas
Formulários
Modelos
Contratos
Documentos Oficiais
```

---

## Chamados É Uma App

Objetivo:

```text
TI
Suporte
Sistemas
Solicitações
Incidentes
```

---

## Manutenção É Uma App

Objetivo:

```text
Infraestrutura
Equipamentos
Predial
Ar-condicionado
Elétrica
Patrimônio
```

---

## Princípio De Visibilidade

### Regra

O usuário visualiza somente Apps autorizadas.

---

### Proibido

```text
Menu bloqueado
Acesso negado visível
App desabilitada aparecendo
Container bloqueado
```

---

### Permitido

Mostrar apenas:

```text
Apps Públicas
Apps Compartilhadas
Apps Permitidas
```

---

## Dashboard Dinâmico

### Regra

Dashboard não pertence à aplicação.
Dashboard pertence ao contexto.

### Fórmula

```text
Dashboard
  =
  App
  +
  Perfil
  +
  Permissões
  +
  Contexto Operacional
```

---

## Exemplo: App Farmácia

### Caixa

```text
Vendas
Ticket Médio
Clientes
Caixa
```

### Farmacêutico

```text
Estoque
Lotes
Validades
Dispensações
```

### Gerente

```text
Metas
Equipe
Margem
Performance
```

### Executivo

```text
BI
KPIs
Comparativos
Rede
```

---

## Identidade ≠ Contexto

### Lei

```text
Usuário é permanente.
Contexto é variável.
```

### Exemplo

Usuário:

```text
Evandro
```

Pode atuar em:

```text
Hospital
Clínica
PDV
Farmácia
SAC
CRM
```

Sem criar nova conta.

---

## Portal Como Launcher

Portal é responsável por:

```text
Navegação
Busca Global
Favoritos
Notificações
App Launcher
Context Selector
```

---

Portal NÃO executa:

```text
Vendas
Atendimento
Financeiro
Farmácia
CRM
SAC
```

---

## Busca Global

Pesquisar em:

```text
Apps
Usuários
Documentos
Cursos
Chamados
Posts
Chats
Clientes
Produtos
```

---

## Workplace Corporativo

Inclui:

```text
Feed Corporativo
Rede Social
Chat
Comunidades
Eventos
Calendário
Reuniões
Colaboração
```

Modelo:

```text
LinkedIn
+
Facebook Workplace
+
Microsoft Teams
```

---

## Compatibilidade Obrigatória

Este documento complementa:

```text
MD-020 Portal Core
MD-028 Enterprise Social Network
MD-029 Digital Workplace
MD-041 Design System
MD-042 Frontend Shell
MD-043 Dashboard Framework
MD-034 IAM
```

---

## Lei Final

```text
Portal é o Sistema Operacional.
Apps são capacidades.
Dashboards são contextuais.
Usuários veem apenas o que podem utilizar.
A experiência é única em todo o ecossistema.
```

---

## Próximos Passos

Atualizar os MDs abaixo para que todos passem a obedecer formalmente a esta lei de experiência do Portal:

1. MD-041 — Design System Enterprise
2. MD-042 — Frontend Shell Architecture
3. MD-043 — Dashboard Framework
