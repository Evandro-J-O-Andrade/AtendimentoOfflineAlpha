# MD-108 — Operational Context Engine

## Status

Documento Canônico de Contexto Operacional.
Define o motor de contexto que governa toda a experiência da plataforma.

---

## Objetivo

Transformar contexto operacional (tenant, unidade, local, perfil) na camada que determina o que cada usuário vê e pode fazer.

---

## Princípio Fundamental

```text
Contexto não é opcional.
Contexto é obrigatório para qualquer operação.
Sem contexto válido, nenhuma app abre.
Sem contexto válido, nenhum dashboard carrega.
Sem contexto válido, nenhuma regra de negócio executa.
```

---

## Entidades de Contexto

### Tenant (Identidade Comercial)

```text
Cliente SaaS.
Contrato principal.
Entidade de faturamento.
Nível máximo de isolamento.
```

### Unidade (Identidade Física/Lógica)

```text
Filial, Hospital, Clínica, Loja, Escritório.
Pertence a um tenant.
Agrupa locais.
Tem configurações próprias.
```

### Local (Identidade Operacional)

```text
Setor, Sala, Guichê, Painel, PDV.
Pertence a uma unidade.
É o nível mais granular de operação.
Determina: apps permitidas, permissões, dashboards, regras de negócio.
```

### Perfil (Identidade Funcional)

```text
Papel do usuário dentro do contexto.
Ex: Médico, Enfermeiro, Farmacêutico, Recepcionista, Gerente, Financeiro.
Não é cargo. É permissão funcional dinâmica.
Muda conforme o contexto.
```

### Sessão (Identidade de Execução)

```text
Instância de acesso ativa.
Carrega: tenant ativo, unidade selecionada, local selecionado, perfil ativo.
Expira por inatividade ou logout.
Pode ser revogada.
```

---

## Context Engine

### Responsabilidades

```text
Resolver tenant padrão do usuário
Resolver unidades disponíveis para o usuário
Resolver locais disponíveis para a unidade
Resolver perfis disponíveis para o contexto
Validar se o contexto atual permite a ação solicitada
Propagar contexto para todas as camadas (backend, Dispatcher, SP, frontend)
```

### Fluxo de Resolução

```
Usuário loga
  ↓
IAM identifica usuário
  ↓
Context Engine carrega tenants do usuário
  ↓
Usuário seleciona tenant (ou tenant padrão)
  ↓
Context Engine carrega unidades do tenant
  ↓
Usuário seleciona unidade (ou unidade padrão)
  ↓
Context Engine carrega locais da unidade
  ↓
Usuário seleciona local (ou local padrão)
  ↓
Context Engine carrega perfis disponíveis
  ↓
Usuário seleciona perfil (ou perfil padrão)
  ↓
Contexto validado e ativo
  ↓
App Registry determina apps permitidas
  ↓
Dashboard carrega widgets por perfil + permissão + contexto
  ↓
Operação liberada
```

---

## Contexto em Cada Camada

### Frontend

```text
Context Provider carrega tenant, unidade, local, perfil.
Todas as requisições carregam contexto no header/auth.
Todas as telas respeitam contexto.
Seleção de contexto é obrigatória antes de abrir app operacional.
Contexto é exibido no header do Shell.
```

### Backend

```text
Middleware extrai contexto do token/sessão.
Middleware valida contexto ativo.
Middleware injeta contexto em todas as requisições downstream.
Nenhuma controller executa sem contexto.
```

### Dispatcher

```text
Recebe contexto como parâmetro obrigatório.
Valida contexto antes de chamar SP.
Nenhuma SP é chamada sem contexto completo.
Contexto é passado como primeiros parâmetros da SP.
```

### Stored Procedure

```text
Recebe contexto como primeiros parâmetros.
Valida contexto internamente (defesa em profundidade).
Usa contexto para filtrar dados e aplicar regras.
Nenhuma SP opera sem contexto explícito.
```

### Event Store

```text
Todo evento carrega contexto completo.
Evento é sempre por tenant.
Evento é sempre por unidade/local quando aplicável.
Consultas de evento filtram por contexto.
```

---

## Regras de Contexto

### Contexto é Obrigatório

```text
Login sem contexto = sessão parcial.
App operacional sem contexto = bloqueada.
Dashboard sem contexto = vazio.
SP sem contexto = erro 422.
```

### Contexto é Variável

```text
Usuário pode trocar de tenant (se autorizado).
Usuário pode trocar de unidade (se autorizado).
Usuário pode trocar de local (se autorizado).
Usuário pode trocar de perfil (se autorizado).
Cada troca gera evento.
Cada troca atualiza sessão.
Cada troca recarrega apps, permissões e dashboards.
```

### Contexto é Validado

```text
Troca de contexto valida permissão.
Troca de contexto valida se app está disponível no novo contexto.
Troca de contexto valida se perfil é válido no novo contexto.
Troca inválida = erro com mensagem clara.
```

---

## Perfis Dinâmicos

```text
Perfil não é cargo fixo.
Perfil é função no contexto.
Ex: Mesmo usuário "Evandro"
  - No Hospital: Perfil Médico
  - Na Clínica: Perfil Administrativo
  - No PDV: Perfil Caixa
  - No CRM: Perfil Gestor
Perfil determina:
  - Apps visíveis
  - Dashboards disponíveis
  - Permissões de ação
  - Regras de negócio aplicáveis
  - Campos visíveis em formulários
  - KPIs exibidos
```

---

## Integrações

```text
MD-003 — Contexto Operacional
MD-017 — Multi-Tenant
MD-034 — Identity Access Management
MD-042A — Portal Experience
MD-043 — Dashboard Framework
MD-019 — App Registry Canônico
MD-025 — Event Store Core
```

---

## Lei

```text
Sem contexto não existe operação.
Contexto é a chave mestra da plataforma.
Contexto une IAM, Apps, Dashboards e Dados.
```

---

## Responsabilidades

Plataforma é responsável por:

```text
Context Engine canônico
Resolução de tenant/unidade/local/perfil
Validação de contexto em todas as camadas
Propagação de contexto
Persistência de contexto na sessão
Auditoria de trocas de contexto
```

Usuários são responsáveis por:

```text
Selecionar contexto correto antes de operar
Reportar contexto incorreto
Não compartilhar sessão
```

---

## Métricas

```text
Trocas de contexto por usuário/dia
Tempo médio de seleção de contexto
Erros de contexto inválido
Apps abertas por contexto
Dashboards carregados por contexto
Sessões com contexto incompleto (alerta)
```
