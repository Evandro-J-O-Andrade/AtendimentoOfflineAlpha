# MD-010 — App Registry Canônico

## Status

Documento Canônico Complementar Da Arquitetura Da Plataforma Enterprise.

---

## Objetivo

Definir o Portal Enterprise como shell universal e ponto único de entrada para todas as aplicações registradas, eliminando acesso direto a módulos e garantindo que toda execução passe pelo Registry.

---

## Princípio Fundamental

```text
O usuário acessa o Portal.
O Portal carrega aplicações registradas.
Nenhuma aplicação existe sem entrada no Registry.
Nenhuma aplicação executa sem permissão e contexto.
```

---

## Fluxo Canônico

```text
Login
  ↓
Portal Shell
  ↓
Auth Canônico
  ↓
App Registry
  ↓
Aplicação Registrada
  ↓
Contexto Operacional (quando necessário)
  ↓
Dispatcher
  ↓
SP
  ↓
Event Store
  ↓
Resposta
```

---

## Responsabilidades Do Portal

Portal é responsável por:

```text
Autenticação unificada
Registro e catálogo de aplicações
Navegação global
Seleção de contexto operacional
Tema e branding dinâmico por tenant
Notificações globais
Dashboard executivo consolidado
Acesso a todas as aplicações registradas
```

Portal não executa regras de negócio assistencial.

---

## App Registry No Portal

Registry é a fonte única de aplicações disponíveis.

```text
Aplicações são carregadas dinamicamente.
Aplicações são ativadas/desativadas por tenant.
Aplicações declaram dependência de contexto.
Shell valida contexto antes de abrir aplicação.
Nenhuma rota de aplicação existe sem entrada no Registry.
```

### Modelo Canônico

```json
{
  "codigo": "FARMACIA",
  "nome": "Farmácia",
  "dominio": "FARMACIA",
  "rota": "/apps/farmacia",
  "contexto_obrigatorio": true,
  "auth_required": true,
  "permissoes": ["FARMACIA.ACESSAR"],
  "sp_namespace": "FARMACIA",
  "event_namespace": "FARMACIA",
  "dashboards": ["FARMACIA_OPERACIONAL", "FARMACIA_GESTAO"],
  "entrypoints": ["UI", "API", "DISPATCHER"],
  "runtime_mode": "ONLINE_OFFLINE_COMPAT",
  "tenant_scope": "MULTI_TENANT"
}
```

---

## Tipos De Aplicação

### Apps Operacionais

```text
FILA
TRIAGEM
ATENDIMENTO
ENFERMAGEM
MEDICO
FARMACIA
ESTOQUE
INTERNACAO
CAT
```

Regra: exigem OperationalContext obrigatório.

### Apps De Portal

```text
BI
AVA
CHAT
REDE_SOCIAL
DOCUMENTOS
WIKI
OUVIDORIA
SAC
```

Regra: não dependem de contexto clínico.

### Apps Financeiras

```text
FATURAMENTO
PDV
FINANCEIRO
CONTRATOS
RECEBIMENTOS
```

### Apps CRM

```text
CRM
CLIENTES
FORNECEDORES
SUPORTE
CHAMADOS
```

### Apps De Infra/Sistema

```text
AUTH
RUNTIME
DISPATCHER
EVENT_STORE
AUDITORIA
SEGURANCA
INTEGRACAO
WEBHOOK
N8N
```

---

## Ciclo De Vida De Aplicação

```text
1. REGISTRO no Registry
2. ATRIBUIÇÃO de permissões
3. MAPEAMENTO de SP namespace
4. MAPEAMENTO de eventos
5. PUBLICAÇÃO no Portal UI
6. DISPONIBILIZAÇÃO no runtime
```

---

## Integração Com Dispatcher

Cada app executa ações exclusivamente via Dispatcher:

```json
{
  "app": "FARMACIA",
  "acao": "DISPENSAR_MEDICAMENTO",
  "payload": {}
}
```

Portal ou frontend não chamam SPs, endpoints ou controllers diretamente.

---

## Integração Com Event Store

Toda app gera eventos padronizados:

```text
FARMACIA_MEDICAMENTO_DISPENSADO
FILA_SENHA_GERADA
TRIAGEM_INICIADA
ATENDIMENTO_FINALIZADO
```

App não grava diretamente no banco. App emite evento.

---

## Regras

1. Toda aplicação entra no sistema exclusivamente pelo Registry.
2. Toda aplicação possui código único e imutável.
3. Toda aplicação define se contexto operacional é obrigatório.
4. Toda aplicação declara permissões mínimas de acesso.
5. Toda aplicação pode ser ativada ou desativada por tenant.
6. Nenhuma aplicação pode carregar módulo não listado no Registry.
7. Nenhuma aplicação pode criar rota sem correspondência no Registry.
8. Registry é consultado no login e no carregamento do Portal.
9. Alterações no Registry requerem migração de configuração versionada.
10. Registry alimenta tanto backend (rotas, permissões) quanto frontend (Shell, menu).

---

## Proibições

São proibidos:

```text
Aplicação ativa sem entrada no Registry
Aplicação carregada por módulo avulso
Rota criada sem correspondência no Registry
Permissão de aplicação hardcoded
Tema definido dentro da aplicação
Módulo listado mas não implementado
Versão de aplicação sem correspondência em código
Alteração manual do Registry em produção
Registry diferente entre backend e frontend
Aplicação acessando Registry de outro tenant
App isolada acessando banco diretamente
App executando regra de negócio fora do Dispatcher
```

---

## Lei Do App Registry

```text
Registry é a porta de entrada de toda aplicação.
Sem Registry, não existe aplicação.
Todo dado pertence ao Portal Core e é consumido por domínios.
```

---










