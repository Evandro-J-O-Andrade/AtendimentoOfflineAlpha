# FRONT-004 — App Registry Navigation

## Status

Documento Canônico de Frontend.
Define como a navegação e o App Registry funcionam na experiência do usuário.

---

## Objetivo

Garantir que toda navegação seja dinâmica, governada por permissões e contexto.

---

## Princípio Fundamental

```text
Nenhuma app existe sem entrada no Registry.
Nenhuma rota é hardcoded.
Nenhum menu é fixo.
Navegação é resolvida em tempo real por:
  Usuário + Tenant + Unidade + Local + Perfil + App Registry.
```

---

## Componentes

### AppRegistryEngine

```text
Consulta catálogo de apps
Resolve apps visíveis para o contexto atual
Aplica filtros de permissão
Retorna lista ordenada para UI
Atualiza automaticamente quando:
  - Contexto muda
  - Permissões mudam
  - Apps são ativadas/desativadas
  - Planos mudam
```

### NavigationResolver

```text
Recebe app selecionada
Resolve rota canônica
Valida contexto antes de navegar
Redireciona para Context Selection se necessário
Atualiza breadcrumb global
Registra evento de navegação
```

### BreadcrumbGlobal

```text
App > Módulo > Página
Atualizado por rota
Clique para retornar a níveis anteriores
Consistente em todas as apps
```

### AppCard / AppLauncherItem

```text
Ícone oficial (canônico)
Nome
Descrição curta
Badge de novidade (opcional)
Flag de contexto necessário (se app requer contexto)
Flag de app externa (se white-label ou integração)
Ação primária: "Abrir"
Ação secundária: "Favoritar"
```

### Sidebar

```text
Agrupamento por categoria/módulo
Ícones canônicos
Indicador de app ativa
Indicador de seletor de contexto
Collapse/expand (perfil de usuário)
```

---

## Regras

### Rotas

```text
Nenhuma rota hardcoded no código.
Rotas são definidas no App Registry (banco).
Rota canônica = /app/{codigo_app}/{modulo?}/{acao?}
Exemplo: /app/farmacia/dispensacao
Exemplo: /app/operacional/recepcao
Exemplo: /app/crm/pipeline
```

### Permissões de Navegação

```text
App sem permissão para o usuário = invisível.
App sem contexto requerido = visível mas bloqueada (redireciona para Context).
App inativa para o tenant = invisível.
App descontinuada = invisível com mensagem de obsolescência (se já acessou antes).
```

### Navegação entre Apps

```text
Troca de app é instantânea (Shell compartilhado).
Contexto é preservado entre apps (se compartilhado).
Abertura de app gera evento (APP_ABERTA).
Fechamento de app retorna ao Portal (não para tela anterior de outra app).
```

### Deep Linking

```text
Deep link respeita contexto.
Exemplo: /app/farmacia/dispensacao/123
  → Se contexto não selecionado → Context Selection primeiro.
  → Se contexto selecionado → abre dispensação #123.
Deep link sem contexto retorna erro amigável.
Tenants podem configurar deep links customizados (whitelabel).
```

---

## Integrações

| MD | Finalidade |
|----|-----------|
| MD-019 — App Registry Canônico | Catálogo de apps, rotas, permissões |
| MD-020 — Portal Core Architecture | Núcleo do Portal |
| MD-042A — Portal Experience | Leis de experiência |
| MD-034 — Identity Access Management | Permissões por app |
| MD-108 — Operational Context Engine | Validação de contexto |
| MD-110 — Canonical Laws | Leis supremas |
| FRONT-001 — Canonical Login Experience | Auth |
| FRONT-002 — Context Selection Experience | Contexto |
| FRONT-003 — Portal Enterprise Experience | Shell |

---

## Responsabilidades

| Camada | Responsabilidade |
|--------|------------------|
| Frontend | App Launcher, Sidebar, Breadcrumbs, Deep Linking |
| Backend | APIs de catálogo, permissões, apps do usuário |
| Dispatcher | Roteamento para SPs de app registry e auth |
| SP | Regras de app visível, permissão, contexto |
| Event Store | Registrar APP_ABERTA, APP_FECHADA, NAVEGACAO |

---

## Métricas

```text
Apps registradas
Apps ativas por tenant
Apps abertas por usuário/dia
Tempo para abrir app (P95)
Apps bloqueadas por falta de contexto (alerta)
Deep links utilizados
Navegação porSidebar vs. App Launcher
Erros de rota não encontrada
```

---

## Lei

```text
Nenhuma app existe sem Registry.
Nenhuma rota é hardcoded.
Nenhum menu é fixo.
Navegação é dinâmica e governada.
```

---

## Próximo

```text
FRONT-004 completo
  ↓
FRONT-005 — Dashboard Framework
```
