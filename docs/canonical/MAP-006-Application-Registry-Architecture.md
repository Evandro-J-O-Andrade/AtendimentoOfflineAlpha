# MAP-006 — Application Registry Architecture

## Status
Documento Canônico de Arquitetura.
Registo e descoberta de aplicações.

---

## Classificação
```text
Tipo: Application Architecture
Camada: Plataforma
Prioridade: Alta
Obrigatoriedade: Global
```

---

## Objetivo
Definir arquitetura do registro, descoberta e execução de aplicações.

---

## Lei Canônica MAP-006-001
```text
Toda app é registrada.
Except apps externas.
```

---

## Leis Canônicas Globais Aplicáveis

### LC-013 — Application Registry é Obrigatório
```text
Nenhum módulo existe sem registro.
Registro mínimo: ID, Nome, Domínio, Permissões, Rotas, Versão, Owner
Portal não conhece apps diretamente.
Sempre via Registry.
```

### LC-001 — Portal é a Entrada Oficial
```text
Login → Portal → Registry → App → Contexto → Dashboard → Operação
```

### LC-002 — Identity ≠ Operational Context
```text
Registry consome identidade de IAM.
Contexto é escolhido após entrar no app.
```

---

## Entidades

### App
```text
app_id (UUID)
tenant_id
name
description
url
category
icon
permissions_required
is_active
is_system
```

### AppAssignment
```text
assignment_id
app_id
role_id
tenant_id
is_mandatory
```

---

## Modelo de Registro

### Registration Flow
```text
1. App registration
2. Permission mapping
3. Context requirements
4. Icon upload
5. Category assignment
```

---

## App Types

### System Apps
```text
Built-in apps
Pre-installed
Cannot unregister
```

### Tenant Apps
```text
Custom apps
Tenant managed
Optional
```

### Marketplace Apps
```text
From marketplace
Auto-provisioned
Version managed
```

---

## Stored Procedures

### sp_app_register
Registrar nova app

### sp_app_assign_to_role
Atribuir app a papel

### sp_app_get_by_user
Apps disponíveis para usuário

### sp_app_validate_access
Validar acesso à app

---

## Eventos Oficiais

### AppRegistered
App registrada

### AppAssigned
App atribuída a papel

### AppAccessed
App acessada

### AppUnregistered
App removida

---

## Integrações
| MAP/MD | Finalidade |
|--------|-----------|
| MAP-005 — Portal | Portal |
| MD-080 — Ecosystem | Marketplace |
| FRONT-004 — App Registry | UX |
| FRONT-026 — Marketplace | Marketplace UX |