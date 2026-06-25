# MD-120 — Party Identity Architecture

## Status
Documento Canônico Supremo.
Arquitetura de identidade de pessoa multi-contexto.

## Classificação
```text
Tipo: Foundation Architecture
Camada: Platform Core
Prioridade: Crítica
Obrigatoriedade: Global
```

## Objetivo
Definir a arquitetura de identidade única de pessoa com múltiplos papéis e contextos, garantindo isolamento multi-tenant e LGPD.

---

## Problema que Resolve
```text
Paciente duplicado entre tenants
CPF como chave primária
Impossibilidade de histórico transversal
Quebra de LGPD
Incompatibilidade com SaaS Multi-Tenant
```

---

# Lei Canônica MD-120-001
```text
Pessoa é a entidade raiz da plataforma Midas.
```

---

# Lei Canônica MD-120-002
```text
Identidade pertence à Pessoa, não ao Tenant.
```

---

# Lei Canônica MD-120-003
```text
Dados pertencem ao Tenant.
```

---

# Lei Canônica MD-120-004
```text
Contexto define visibilidade dos dados.
```

---

# Lei Canônica MD-120-005
```text
Uma Pessoa pode existir em múltiplos Tenants simultaneamente.
```

---

# Hierarquia Oficial
```text
Pessoa (Global)
    ↓
Identidade
    ↓
Papéis
    ↓
Tenant/Membros
    ↓
Contextos
    ↓
Acesso aos Dados
```

---

# Modelo Party/Role

## Entidade Pessoa
Entidade raiz única na plataforma.

```text
person_id (UUID)
tenant_master_id (FK)
nome
nome_social
data_nascimento
sexo
cpf
rg
estado_civil
tipo_sanguineo
altura
peso
fotografia
status
created_at
updated_at
```

---

## Entidade Identidade
Representa credenciais de acesso.

```text
identity_id (UUID)
person_id (FK)
email
telefone
celular
usuario
senha_hash
mfa_enabled
status
created_at
updated_at
```

---

## Entidade Papel
Relaciona Pessoa a funções.

```text
role_assignment_id (UUID)
person_id (FK)
role_type
role_id
tenant_id
status
valid_from
valid_to
```

role_type:
```text
PACIENTE
USUARIO
MEDICO
ENFERMEIRO
FARMACEUTICO
FUNCIONARIO
PRESTADOR
FORNECEDOR
BENEFICIARIO
RESPONSAVEL
ACOMPANHANTE
```

---

# Contextos Disponíveis

## Paciente
Contexto assistencial.

Dados visíveis:
```text
Atendimentos
Exames
Receitas
Documentos
Internações
Faturamento
```

---

## Prestador
Contexto de serviço.

Dados visíveis:
```text
Atendimentos realizados
Procedimentos
Faturas
```

---

## Funcionário
Contexto administrativo.

Dados visíveis:
```text
Escala
Treinamento
Folha
Benefícios
```

---

# Operação Multi-Tenant

## Paciente existente
Quando Pessoa já existe:

```text
Cadastrar nova role PACIENTE
No novo tenant
Vincular a existing person_id
```

---

## Paciente novo
Quando CPF não existe:

```text
Criar nova Pessoa
Criar nova role PACIENTE
No tenant atual
Criar Identidade
Gerar login automático
```

---

# LGPD Compliance

## Isolamento de Dados
```text
SELECT dados_assistenciais
FROM atendimentos a
JOIN person_roles pr ON a.patient_role_id = pr.role_assignment_id
WHERE pr.person_id = ?
AND pr.tenant_id = ?
```

---

## Consentimento
Todo Tenant deve possuir:

```text
Termo de Consentimento
Data consentimento
Finalidade
Escopo
```

---

# Eventos Oficiais

### PessoaCriada
Payload: {person_id, cpf, nome}

### PessoaAtualizada
Payload: {person_id, campo, valor_anterior, valor_novo}

### RoleAtribuido
Payload: {role_assignment_id, person_id, role_type, tenant_id}

### ContextoSelecionado
Payload: {person_id, tenant_id, role_type, timestamp}

---

# Stored Procedures

### sp_person_criar
Input: {cpf, nome, data_nascimento}
Output: {person_id, existing}

### sp_role_atribuir
Input: {person_id, role_type, tenant_id, dados}
Output: {role_assignment_id}

### sp_login_pessoa
Input: {cpf, senha}
Output: {contextos_disponiveis}

---

# Integrações
| MAP/MD | Finalidade |
|--------|-----------|
| MAP-003 — Identity Architecture | Identidade |
| MAP-002 — Tenant Architecture | Isolamento |
| MD-110 — Canonical Laws | Leis |

---

# Exemplo Prático

Paciente João:

```text
PessoaID: 100
CPF: 123.456.789-00
Nome: João Silva
```

---

Hoje:

```text
Tenant A (Hospital)
Role: PACIENTE
PatientID: 200
```

---

Amanhã:

```text
Tenant B (UPA)
Role: PACIENTE
PatientID: 300
```

---

Portal:

```text
João entra
↓
Mostra Contextos Disponíveis
↓
Hospital A
↓
UPA B
```

---

# Status
```text
MD-001 → MD-119 ✅

MD-120 ✅ Party Identity Architecture
```

---

# Próximos
```text
MD-121 — Patient Experience Architecture

MD-122 — Multi-Tenant Identity Bridge

MD-123 — Citizen Identity Protocol
```