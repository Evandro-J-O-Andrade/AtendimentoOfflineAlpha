# MAP-002 — Tenant Architecture

## Status
Documento Canônico de Arquitetura.
Fundamento do multi-tenancy e isolamento de dados.

---

## Classificação
```text
Tipo: Foundation Architecture
Camada: Plataforma
Prioridade: Crítica
Obrigatoriedade: Global
```

---

## Objetivo
Definir a arquitetura oficial de multi-tenancy da Plataforma Midas, estabelecendo isolamento, hierarquia organizacional, escopo de dados, contexto operacional, permissões e particionamento.

---

## Problema que Resolve
```text
Mistura de dados

Acesso indevido

Quebra de isolamento

Consultas globais perigosas

Acoplamento entre empresas
```

---

## Lei Canônica MAP-002-001
```text
Tenant é a fronteira máxima de dados.
```

---

## Lei Canônica MAP-002-002
```text
Nenhuma operação pode ultrapassar
os limites de um tenant
sem autorização explícita.
```

---

## Lei Canônica MAP-002-003
```text
Todo dado pertence a um tenant.
```

---

## Lei Canônica MAP-002-004
```text
Não existem registros órfãos
fora de tenant.
```

---

## Hierarquia Oficial
```text
Tenant
    ↓
Organização
    ↓
Unidade
    ↓
Setor
    ↓
Local
```

---

## Definições

### Tenant
Representa:
```text
Empresa
Grupo Empresarial
Rede Hospitalar
Franquia
Holding
```

### Organização
Representa a estrutura administrativa. Exemplo:
```text
Hospital São Lucas
```

### Unidade
Representa:
```text
Filial
Hospital
Clínica
UPA
UBS
Farmácia
```

### Setor
Representa:
```text
Recepção
Farmácia
UTI
Financeiro
RH
```

### Local
Representa:
```text
Sala
Consultório
Leito
Guichê
Estação
```

---

## Agregados Principais

### Tenant Aggregate
Entidades:
```text
Tenant
Plano
Licença
Configuração
Domínio
```

### Organization Aggregate
Entidades:
```text
Organização
Departamento
Estrutura
```

### Unit Aggregate
Entidades:
```text
Unidade
Endereço
Capacidade
Especialidades
```

---

## Chaves Obrigatórias
Toda entidade operacional deve possuir:
```text
tenant_id
organization_id
unit_id
```

---

## Chaves Opcionais
Quando aplicável:
```text
sector_id
location_id
```

---

## Contexto Operacional
Toda sessão ativa deve possuir:
```text
Tenant
Organização
Unidade
Perfil
Usuário
```

---

## Lei de Contexto
```text
Nenhuma operação ocorre
fora de contexto.
```

---

## Isolamento de Dados

### Obrigatório
Toda consulta deve filtrar:
```sql
WHERE tenant_id = ?
```

### Proibido
```sql
SELECT * FROM pacientes
```

### Correto
```sql
SELECT *
FROM pacientes
WHERE tenant_id = ?
```

---

## Particionamento

### Nível Lógico
Obrigatório:
```text
tenant_id
```
em todas as entidades.

### Nível Físico
Preparado para:
```text
Database per Tenant
Schema per Tenant
Shared Database
```

---

## Estratégia Oficial Inicial
```text
Shared Database + Tenant Isolation
```

---

## Evolução
Permitir futuramente:
```text
Tenant Premium → Database Exclusivo
```

---

## Segurança
Toda requisição deve validar:
```text
tenant_id
user_id
context_id
permissions
```

---

## Eventos Oficiais

### TenantCreated
Novo tenant criado

### TenantActivated
Tenant ativado

### TenantSuspended
Tenant suspenso

### TenantMigrated
Tenant migrado

---

## Integração com IAM
IAM é responsável por Identidade. Tenant é responsável por Escopo.

---

## Lei Importante
```text
Usuário não pertence ao sistema.
Usuário pertence ao tenant.
```

---

## Integração com Billing
Tenant possui:
```text
Plano
Limites
Licenças
Consumo
```

---

## Observabilidade
Monitorar:
```text
Usuários
Sessões
Consumo
Storage
APIs
Eventos
```

---

## Escalabilidade
Permitir:
```text
1 tenant → 10000 tenants
```
sem alteração arquitetural.

---

## Anti-Pattern Proibido

### Cross Tenant Query
Proibido:
```sql
SELECT * FROM pacientes
```
sem escopo.

### Shared Permission
Proibido:
```text
Permissões globais ignorando tenant.
```

---

## Governança
Todo tenant deve possuir:
```text
Administrador
Plano
Status
Configuração
Auditoria
```

---

## Integrações
| MAP/MD | Finalidade |
|--------|-----------|
| MAP-001 — Enterprise Domain | Domínios |
| MD-107 — Tenant Architecture | Tenant |
| MD-098 — Risk Management | Segurança |
| MD-058 — Multi-Tenant Billing | Billing |