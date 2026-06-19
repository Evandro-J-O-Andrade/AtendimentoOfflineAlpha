# MD-020 — Portal Core Architecture

## Status

Documento Canônico Complementar Da Arquitetura Da Plataforma Enterprise.
Obs: MD-009 já estava em uso como AI-Orchestration. Este documento cobre Portal Core sem renumerar o existente.

---

## Objetivo

Definir o Portal como núcleo absoluto da plataforma SaaS enterprise multi-tenant, responsável por UI, navegação, registry, dashboards, social, apps e governança visual.

---

## Princípio Fundamental

```text
Nada existe fora do Portal.
Toda aplicação nasce do Portal.
Toda execução passa pelo Portal.
```

---

## Princípios

1. Portal é o sistema operacional da plataforma.
2. Aplicações são apps registradas, não módulos fixos.
3. Navegação é dinâmica via App Registry.
4. UI é única, governada por Design System.
5. Dashboards são first-class citizens.
6. Multi-tenant é transversal ao Portal.
7. Offline-first é suportado pelo Runtime.
8. Segurança é camada transversal obrigatória.

---

## Núcleo Do Portal

### Portal Core UI

- Shell visual
- Navegação global
- App launcher
- Context selector
- Dashboard global
- Notificações
- Feed social interno
- Chat corporativo

### App Registry Engine

- Catálogo de apps
- Lifecycle de apps
- Permissões por app
- Metadados de UI
- Ativação por tenant

### Navigation Engine

- Rotas dinâmicas
- Breadcrumb global
- Permissão de rota
- Contexto obrigatório por app

### Context Engine

- Tenant ativo
- Unidade selecionada
- Local selecionado
- Perfil ativo
- Sessão válida

---

## Aplicações Registradas (Exemplos)

```
OPERACIONAL
FARMACIA
ESTOQUE
PDV
FATURAMENTO
FINANCEIRO
CRM
SAC
BI
AVA
DOCUMENTOS
WIKI
OUVIDORIA
CHAT
SOCIAL
ADMIN
```

---

## Regras

1. Nenhuma aplicação existe sem entrada no Registry.
2. Nenhuma rota é criada diretamente; toda rota vem do Registry.
3. Nenhuma app define design system próprio.
4. Dashboards globais são providos pelo Portal.
5. Todo acesso é logado no Event Store.
6. Isolamento multi-tenant é obrigatório.
7. Offline-first é suportado via Runtime.

---

## Proibições

São proibidos:

```text
App sem Registry
Rota hardcoded
UI fora do Design System
Dashboard isolado por app sem integração
Acesso direto a banco por app
Componente visual duplicado
Token armazenado em localStorage
```

---

## Lei

```text
Portal é a porta.
Toda aplicação passa pela porta.
Nenhuma aplicação existe fora do Registry.
```

---

## Responsabilidades

Plataforma é responsável por:

```text
Shell funcionar como porta única
Registry estar sempre atualizado
Auth e Contexto disponíveis
Design System consistente
Performance do Shell
Segurança da navegação
Dashboards globais
```

Aplicações são responsáveis por:

```text
Funcionar dentro do Shell
Respeitar contratos do Registry
Usar componentes do Design System
Usar Dispatcher canônico
Respeitar permissões recebidas
NÃO implementar funcionalidades do Shell
```
