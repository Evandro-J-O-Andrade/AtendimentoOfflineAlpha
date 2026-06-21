# MD-034 — Identity Access Management

## Status

Documento Canônico de Identidade, Acesso e Permissão da Plataforma Enterprise.

---

## Objetivo

Definir o novo modelo de usuários, apps, escopos, tenants, perfis dinâmicos e permissões do Portal Enterprise sem depender de cargos fixos como `Gestor HIS` ou `Gestor CRM`.

---

## Lei Fundamental

```text
Acesso não é cargo.

Acesso é decisão.

Decisão é identidade
+ tenant
+ app
+ escopo
+ permissão
+ contexto.
```

---

## Princípio

Nenhuma App decide quem pode acessar.

O Identity Access Management resolve autorização de forma centralizada, auditável e multi-tenant.

---

## Modelo de Identidade

Usuário:

```json
{
  "id_usuario": "UUID",
  "nome": "string",
  "email": "string",
  "status": "ACTIVE",
  "tenants": [],
  "perfis_dinamicos": [],
  "created_at": "datetime"
}
```

Sessão:

```json
{
  "id_sessao": "UUID",
  "id_usuario": "UUID",
  "id_tenant": 0,
  "id_unidade": 0,
  "id_local": 0,
  "device_fingerprint": "string",
  "ip": "string",
  "user_agent": "string",
  "expires_at": "datetime"
}
```

---

## Modelo de App

Toda App registrada deve declarar capacidades:

```json
{
  "app": "FINANCEIRO",
  "tenant_id": 0,
  "status": "ACTIVE",
  "capabilities": [
    "PAGAMENTO_LER",
    "PAGAMENTO_APROVAR",
    "RELATORIO_EXPORTAR"
  ],
  "requires_context": true
}
```

Regras:

1. App só existe se estiver no App Registry.
2. App declara ações e capacidades.
3. App não define permissão própria.
4. App não assume cargo fixo.
5. App recebe apenas permissões resolvidas para seu contexto.

---

## Modelo de Escopo

Escopo define o limite de atuação:

```text
Tenant
Unidade
Local
Departamento
Perfil
Dispositivo
Horário
Recurso
```

Exemplo:

```json
{
  "tenant_id": 10,
  "unidade_id": 20,
  "local_id": 30,
  "departamento": "FINANCEIRO",
  "recurso": "PAGAMENTO",
  "horario": "COMERCIAL"
}
```

Regras:

1. Escopo é obrigatório para autorização.
2. Escopo vem da sessão e da política.
3. Escopo nunca vem apenas do frontend.
4. Escopo deve ser auditado.
5. Escopo não pode expandir tenant.

---

## Perfis Dinâmicos

Perfil dinâmico é composto por atributos, não por cargo fixo.

Exemplo:

```json
{
  "perfil": "APROVADOR_PAGAMENTO",
  "origem": "POLICY",
  "condicoes": [
    {
      "app": "FINANCEIRO",
      "acao": "PAGAMENTO_APROVAR",
      "tenant_id": 10,
      "unidade_id": 20,
      "limite_valor": 5000
    }
  ]
}
```

Regras:

1. Perfil dinâmico é calculado em runtime.
2. Perfil dinâmico considera atributos do usuário, tenant, app, contexto e risco.
3. Perfil dinâmico não substitui validação de SP.
4. Perfil dinâmico deve ser auditável.
5. Perfil dinâmico deve expirar quando as condições mudam.

---

## Permissões

Permissão é a decisão final:

```json
{
  "usuario_id": "UUID",
  "tenant_id": 10,
  "app": "FINANCEIRO",
  "acao": "PAGAMENTO_APROVAR",
  "escopo": {
    "unidade_id": 20,
    "local_id": 30
  },
  "permitido": true,
  "motivo": "POLICY_MATCH",
  "audit_id": "UUID"
}
```

Regras:

1. Permissão é resolvida por política.
2. Permissão não é hardcoded.
3. Permissão deve considerar tenant.
4. Permissão deve considerar contexto.
5. Permissão deve considerar dispositivo e risco quando aplicável.
6. Permissão negativa deve ser auditada.
7. Permissão positiva deve ser auditada.

---

## Decisão de Acesso

Fluxo:

```text
Usuário
↓
Sessão
↓
Tenant
↓
Contexto
↓
App
↓
Ação
↓
Escopo
↓
Perfil Dinâmico
↓
ACL
↓
Decisão
↓
Evento
```

Regras:

1. Decisão ocorre antes da execução.
2. Decisão é centralizada no IAM.
3. Dispatcher consulta IAM antes de executar ação.
4. SP valida tenant e permissão antes de executar negócio.
5. Toda decisão gera evento.

---

## Integração com RBAC, ABAC e ACL

```text
RBAC
Define papel macro.

ABAC
Define atributos e contexto.

ACL
Define permissão granular por ação.
```

A decisão final combina:

```text
RBAC + ABAC + ACL + Tenant + Contexto + Risco
```

---

## Regras Canônicas

1. Nenhum cargo fixo define acesso sozinho.
2. Nenhuma App implementa autenticação própria.
3. Nenhuma App implementa autorização própria.
4. Todo usuário pertence a pelo menos um tenant.
5. Todo acesso exige contexto.
6. Toda permissão exige app e ação.
7. Toda decisão exige auditoria.
8. Todo tenant pode ter políticas próprias dentro dos limites da plataforma.
9. Super Admin só acessa outros tenants por política explícita.
10. Revogação de permissão deve surtir efeito imediato.

---

## Proibições

```text
Gestor HIS como cargo fixo universal

Gestor CRM como cargo fixo universal

Permissão hardcoded em App

App decidindo quem pode acessar

Auth próprio por domínio

Sessão própria por App

Permissão sem tenant

Permissão sem contexto

Permissão sem ação

Permissão sem auditoria

Bypass do IAM

Bypass do Dispatcher

Bypass da SP
```

---

## Integração Com Outros MDs

- **MD-002 (Auth)**: identidade, sessão, perfil, permissão e tenant.
- **MD-003 (Operational Context)**: contexto operacional obrigatório.
- **MD-004 (Dispatcher)**: consulta autorização antes de executar ação.
- **MD-005 (Event Store)**: registra decisões de acesso.
- **MD-017 (MultiTenant)**: isolamento por tenant.
- **MD-019 (App Registry)**: apps e capacidades registradas.
- **MD-023 (Action Registry)**: ações canônicas executáveis.
- **MD-026 (Security Zero Trust)**: segurança, sessão, JWT, tenant e auditoria.
- **MD-033 (Analytics Governance)**: consumo de métricas de acesso e risco.

---

## Lei Final

```text
Usuário não acessa App.

Usuário acessa ação.

Ação só existe dentro de tenant.

Tenant só existe dentro de contexto.

Contexto só existe com sessão.

Sessão só existe com auditoria.
```

---
