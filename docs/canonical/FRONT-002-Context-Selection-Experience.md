# FRONT-002 — Context Selection Experience

## Status

Documento Canônico de Frontend.
Define a experiência de seleção de contexto operacional.

---

## Objetivo

Separar identidade de operação.
Garantir que o usuário Never acesse app operacional sem contexto válido.

---

## Princípio Fundamental

```text
Login resolve: QUEM É.
Contexto resolve: ONDE OPERA.

Identidade ≠ Contexto Operacional
```

---

## Fluxo Canônico

```
Login (FRONT-001)
  ↓
Context Selection (este documento)
  ↓
  ├── Selecionar Tenant (se múltiplo)
  ├── Selecionar Unidade
  ├── Selecionar Local
  └── Selecionar Perfil
  ↓
Portal Corporativo (FRONT-003)
  ↓
App Registry (apps autorizadas para o contexto)
  ↓
Aplicação
  ↓
Dashboard (App + Perfil + Permissão + Contexto)
```

---

## Componentes

### TenantSelector

```text
Lista de tenants do usuário
Nome, logo, plano
Seleção única
Tenant padrão pré-selecionado (se houver)
```

### UnidadeSelector

```text
Lista de unidades do tenant
Nome, CNES/endereço (saúde)
Filtro por texto
Seleção única
Unidade padrão pré-selecionada (se houver)
```

### LocalSelector

```text
Lista de locais da unidade
Nome, tipo (recepção, consultório, farmácia)
Filtro por tipo (opcional)
Seleção única
Local padrão pré-selecionado (se houver)
```

### PerfilSelector

```text
Lista de perfis disponíveis para o contexto
Nome, escopo, descrição
Seleção única
Perfil padrão pré-selecionado (se houver)
```

### SummaryCard

```text
Resumo da seleção antes de confirmar
  Tenant: Nome
  Unidade: Nome
  Local: Nome
  Perfil: Nome
Botão "Confirmar e Entrar"
```

---

## Regras

### Contexto é Obrigatório

```text
App operacional NUNCA abre sem contexto selecionado.
Tentativa de acesso direto a app operacional
  → redireciona para Context Selection.
Contexto incompleto (faltando unidade/local)
  → bloqueia entrada na app.
```

### Contexto é Variável

```text
Usuário pode trocar de contexto a qualquer momento
  → via seletor no header do Portal.
Troca de contexto gera evento.
Troca de contexto atualiza sessão.
Troca de contexto recarrega:
  - Apps autorizadas
  - Permissões
  - Dashboards
  - Dados
```

### Contexto é Validado

```text
Seleção de tenant valida: usuário pertence ao tenant?
Seleção de unidade valida: unidade pertence ao tenant?
Seleção de local valida: local pertence à unidade?
Seleção de perfil valida: perfil disponível no contexto?
Qualquer falha → erro com mensagem clara + retorno ao seletor.
```

---

## Estados da Tela

| Estado | Comportamento |
|--------|---------------|
| Loading | Carregando tenants/unidades/locais/perfis |
| Ready | Seletor disponível para interação |
| Submitting | Confirmando contexto, chamando API |
| Success | Redirecionamento para Portal |
| Error | Mensagem de erro, retry disponível |
| NoTenant | "Nenhum tenant disponível. Contate o administrador." |
| NoUnidade | "Nenhuma unidade disponível para este tenant." |

---

## Integrações

| MD | Finalidade |
|----|-----------|
| MD-003 — Contexto Operacional | Entidades de contexto |
| MD-017 — Multi-Tenant | Isolamento por tenant |
| MD-034 — Identity Access Management | Permissões, perfis dinâmicos |
| MD-108 — Operational Context Engine | Motor de resolução de contexto |
| MD-107 — Tenant Architecture | Ciclo de vida, planos |
| MD-110 — Canonical Laws | Leis supremas |
| FRONT-001 — Canonical Login Experience | Tela anterior |
| FRONT-003 — Portal Enterprise Experience | Próxima tela |

---

## Responsabilidades

| Camada | Responsabilidade |
|--------|------------------|
| Frontend | Capturar seleção, validar obrigatoriedade, chamar API |
| Backend | Validar sessão, validar permissão de acesso ao contexto |
| Dispatcher | Roteamento para sp_contexto_* ou sp_auth_contexto_set |
| SP | Validar tenant/unidade/local/perfil, persistir contexto na sessão |
| Event Store | Registrar CONTEXTO_SELECIONADO |

---

## Métricas

```text
Tempo médio de seleção de contexto
Taxa de abandono na seleção
Erros de contexto inválido
Trocas de contexto por usuário/dia
Contextos sem unidade/local (alerta)
```

---

## Lei

```text
Identidade ≠ Contexto Operacional
Login resolve: QUEM É
Contexto resolve: ONDE OPERA
Sem contexto, nenhuma app operacional abre
```

---

## Próximo

```text
FRONT-002 completo
  ↓
FRONT-003 — Portal Enterprise Experience
```
