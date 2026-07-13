# MODEL-PHYSICAL-KERNEL

## Status

```text
CANÔNICO (ARQUITETURA)
CICLO 2 — Kernel Enterprise
Modelo físico do Kernel.
```

---

## 1. Propósito

Este documento apresenta o **modelo físico do Kernel** da plataforma New Wave Enterprise.

Ele serve para:
- Definir tabelas, colunas, tipos e constraints
- Definir índices
- Definir chaves estrangeiras
- Orientar geração de SQL
- Servir como referência para implementação

Modelo físico não é SQL.
Modelo físico é **a representação física dos dados**.

---

## 2. Princípio Fundamental

```text
Banco MySQL é a Fonte da Verdade.
Stored Procedures são a única porta de escrita.
Views são para leitura.
Functions são para cálculo.
Triggers são proibidas para lógica.
Nenhuma deleção física.
```

---

## 3. Convenções

### 3.1 Nomenclatura

```text
Tabelas: snake_case, plural
  Exemplo: pessoa, usuario, tenant, sessao, contexto

Colunas: snake_case
  Exemplo: id_pessoa, nome_completo, data_criacao

Índices: idx_{tabela}_{coluna}
  Exemplo: idx_usuario_tenant

Constraints:
  PK: pk_{tabela}
  FK: fk_{tabela}_{coluna}

SPs: sp_{acao}_{entidade}
  Exemplo: sp_usuario_get, sp_tenant_create

Views: vw_{descricao}
  Exemplo: vw_usuario_summary
```

### 3.2 Tipos

| Tipo | Uso |
|------|-----|
| BIGINT | Chaves primárias, IDs |
| VARCHAR(255) | Textos curtos |
| TEXT | Textos longos |
| BOOLEAN | Flags |
| DATETIME | Timestamps |
| JSON | Dados estruturados |
| DECIMAL(10,2) | Valores monetários |

---

## 4. Tabelas

### 4.1 Foundation Layer

#### pessoa

```sql
CREATE TABLE pessoa (
  id_pessoa BIGINT NOT NULL AUTO_INCREMENT,
  nome_completo VARCHAR(255) NOT NULL,
  documento VARCHAR(20) NULL,
  email VARCHAR(255) NULL,
  telefone VARCHAR(20) NULL,
  status ENUM('ativo', 'inativo', 'bloqueado', 'pendente', 'suspenso') NOT NULL DEFAULT 'ativo',
  criado_em DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  criado_por VARCHAR(255) NOT NULL,
  alterado_em DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  alterado_por VARCHAR(255) NOT NULL,
  excluido_em DATETIME NULL,
  excluido_por VARCHAR(255) NULL,
  PRIMARY KEY (id_pessoa),
  INDEX idx_pessoa_documento (documento),
  INDEX idx_pessoa_email (email),
  INDEX idx_pessoa_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
```

#### usuario

```sql
CREATE TABLE usuario (
  id_usuario BIGINT NOT NULL AUTO_INCREMENT,
  id_pessoa BIGINT NOT NULL,
  login VARCHAR(255) NOT NULL,
  senha_hash VARCHAR(255) NOT NULL,
  mfa_ativo BOOLEAN NOT NULL DEFAULT FALSE,
  mfa_secret VARCHAR(255) NULL,
  ultimo_login DATETIME NULL,
  status ENUM('ativo', 'inativo', 'bloqueado', 'pendente', 'suspenso') NOT NULL DEFAULT 'ativo',
  criado_em DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  criado_por VARCHAR(255) NOT NULL,
  alterado_em DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  alterado_por VARCHAR(255) NOT NULL,
  excluido_em DATETIME NULL,
  excluido_por VARCHAR(255) NULL,
  PRIMARY KEY (id_usuario),
  UNIQUE KEY uk_usuario_login (login),
  CONSTRAINT fk_usuario_pessoa FOREIGN KEY (id_pessoa) REFERENCES pessoa (id_pessoa),
  INDEX idx_usuario_pessoa (id_pessoa),
  INDEX idx_usuario_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
```

#### identidade_tecnica

```sql
CREATE TABLE identidade_tecnica (
  id_identidade BIGINT NOT NULL AUTO_INCREMENT,
  tipo ENUM('servico', 'api', 'terminal', 'display', 'agente') NOT NULL,
  nome VARCHAR(255) NOT NULL,
  credencial VARCHAR(255) NOT NULL,
  descricao TEXT NULL,
  status ENUM('ativo', 'inativo', 'bloqueado') NOT NULL DEFAULT 'ativo',
  criado_em DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  criado_por VARCHAR(255) NOT NULL,
  alterado_em DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  alterado_por VARCHAR(255) NOT NULL,
  excluido_em DATETIME NULL,
  excluido_por VARCHAR(255) NULL,
  PRIMARY KEY (id_identidade),
  UNIQUE KEY uk_identidade_credencial (credencial),
  INDEX idx_identidade_tipo (tipo),
  INDEX idx_identidade_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
```

#### tenant

```sql
CREATE TABLE tenant (
  id_tenant BIGINT NOT NULL AUTO_INCREMENT,
  nome VARCHAR(255) NOT NULL,
  documento VARCHAR(20) NULL,
  tipo ENUM('empresa', 'departamento', 'projeto', 'entidade') NOT NULL DEFAULT 'empresa',
  status ENUM('criado', 'configurando', 'ativo', 'suspenso', 'desativado', 'arquivado') NOT NULL DEFAULT 'criado',
  configuracao JSON NULL,
  criado_em DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  criado_por VARCHAR(255) NOT NULL,
  alterado_em DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  alterado_por VARCHAR(255) NOT NULL,
  excluido_em DATETIME NULL,
  excluido_por VARCHAR(255) NULL,
  PRIMARY KEY (id_tenant),
  UNIQUE KEY uk_tenant_documento (documento),
  INDEX idx_tenant_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
```

#### pessoa_tenant

```sql
CREATE TABLE pessoa_tenant (
  id_pessoa_tenant BIGINT NOT NULL AUTO_INCREMENT,
  id_pessoa BIGINT NOT NULL,
  id_tenant BIGINT NOT NULL,
  papel VARCHAR(255) NULL,
  status ENUM('ativo', 'inativo', 'pendente') NOT NULL DEFAULT 'ativo',
  criado_em DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  criado_por VARCHAR(255) NOT NULL,
  PRIMARY KEY (id_pessoa_tenant),
  UNIQUE KEY uk_pessoa_tenant (id_pessoa, id_tenant),
  CONSTRAINT fk_pessoa_tenant_pessoa FOREIGN KEY (id_pessoa) REFERENCES pessoa (id_pessoa),
  CONSTRAINT fk_pessoa_tenant_tenant FOREIGN KEY (id_tenant) REFERENCES tenant (id_tenant),
  INDEX idx_pessoa_tenant_pessoa (id_pessoa),
  INDEX idx_pessoa_tenant_tenant (id_tenant)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
```

#### sessao

```sql
CREATE TABLE sessao (
  id_sessao BIGINT NOT NULL AUTO_INCREMENT,
  id_usuario BIGINT NOT NULL,
  id_tenant BIGINT NOT NULL,
  token VARCHAR(255) NOT NULL,
  refresh_token VARCHAR(255) NULL,
  ip_address VARCHAR(45) NULL,
  user_agent TEXT NULL,
  estado ENUM('criada', 'autenticada', 'ativa', 'ociosa', 'expirada', 'revogada', 'encerrada') NOT NULL DEFAULT 'criada',
  criado_em DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  autenticado_em DATETIME NULL,
  iniciado_em DATETIME NULL,
  expira_em DATETIME NOT NULL,
  encerrado_em DATETIME NULL,
  PRIMARY KEY (id_sessao),
  UNIQUE KEY uk_sessao_token (token),
  CONSTRAINT fk_sessao_usuario FOREIGN KEY (id_usuario) REFERENCES usuario (id_usuario),
  CONSTRAINT fk_sessao_tenant FOREIGN KEY (id_tenant) REFERENCES tenant (id_tenant),
  INDEX idx_sessao_usuario (id_usuario),
  INDEX idx_sessao_tenant (id_tenant),
  INDEX idx_sessao_estado (estado),
  INDEX idx_sessao_expira_em (expira_em)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
```

#### contexto

```sql
CREATE TABLE contexto (
  id_contexto BIGINT NOT NULL AUTO_INCREMENT,
  id_usuario BIGINT NOT NULL,
  id_tenant BIGINT NOT NULL,
  id_sessao BIGINT NOT NULL,
  id_unidade BIGINT NULL,
  id_local BIGINT NULL,
  id_perfil BIGINT NULL,
  id_sistema BIGINT NULL,
  id_aplicacao BIGINT NULL,
  ambiente ENUM('producao', 'homologacao', 'treinamento') NOT NULL DEFAULT 'producao',
  runtime ENUM('web', 'mobile', 'api', 'display', 'totem') NOT NULL DEFAULT 'web',
  estado ENUM('resolvido', 'ativo', 'trocando', 'invalido', 'suspenso', 'encerrado') NOT NULL DEFAULT 'resolvido',
  criado_em DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  criado_por VARCHAR(255) NOT NULL,
  alterado_em DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  alterado_por VARCHAR(255) NOT NULL,
  PRIMARY KEY (id_contexto),
  CONSTRAINT fk_contexto_usuario FOREIGN KEY (id_usuario) REFERENCES usuario (id_usuario),
  CONSTRAINT fk_contexto_tenant FOREIGN KEY (id_tenant) REFERENCES tenant (id_tenant),
  CONSTRAINT fk_contexto_sessao FOREIGN KEY (id_sessao) REFERENCES sessao (id_sessao),
  INDEX idx_contexto_usuario (id_usuario),
  INDEX idx_contexto_tenant (id_tenant),
  INDEX idx_contexto_sessao (id_sessao),
  INDEX idx_contexto_estado (estado)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
```

### 4.2 Governance Layer

#### auth_policy

```sql
CREATE TABLE auth_policy (
  id_policy BIGINT NOT NULL AUTO_INCREMENT,
  id_tenant BIGINT NULL,
  nome VARCHAR(255) NOT NULL,
  tipo ENUM('global', 'tenant', 'usuario') NOT NULL DEFAULT 'global',
  regra JSON NOT NULL,
  status ENUM('ativo', 'inativo') NOT NULL DEFAULT 'ativo',
  criado_em DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  criado_por VARCHAR(255) NOT NULL,
  alterado_em DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  alterado_por VARCHAR(255) NOT NULL,
  PRIMARY KEY (id_policy),
  INDEX idx_auth_policy_tenant (id_tenant),
  INDEX idx_auth_policy_tipo (tipo)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
```

#### auth_role

```sql
CREATE TABLE auth_role (
  id_role BIGINT NOT NULL AUTO_INCREMENT,
  id_policy BIGINT NOT NULL,
  nome VARCHAR(255) NOT NULL,
  descricao TEXT NULL,
  status ENUM('ativo', 'inativo') NOT NULL DEFAULT 'ativo',
  criado_em DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  criado_por VARCHAR(255) NOT NULL,
  alterado_em DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  alterado_por VARCHAR(255) NOT NULL,
  PRIMARY KEY (id_role),
  CONSTRAINT fk_auth_role_policy FOREIGN KEY (id_policy) REFERENCES auth_policy (id_policy),
  INDEX idx_auth_role_policy (id_policy)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
```

#### auth_permission

```sql
CREATE TABLE auth_permission (
  id_permission BIGINT NOT NULL AUTO_INCREMENT,
  id_role BIGINT NOT NULL,
  recurso VARCHAR(255) NOT NULL,
  operacao ENUM('ler', 'criar', 'alterar', 'excluir', 'executar', 'administrar') NOT NULL,
  status ENUM('ativo', 'inativo') NOT NULL DEFAULT 'ativo',
  criado_em DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  criado_por VARCHAR(255) NOT NULL,
  PRIMARY KEY (id_permission),
  CONSTRAINT fk_auth_permission_role FOREIGN KEY (id_role) REFERENCES auth_role (id_role),
  INDEX idx_auth_permission_role (id_role),
  INDEX idx_auth_permission_recurso (recurso)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
```

#### auth_decision

```sql
CREATE TABLE auth_decision (
  id_decision BIGINT NOT NULL AUTO_INCREMENT,
  id_identity BIGINT NOT NULL,
  id_tenant BIGINT NOT NULL,
  id_session BIGINT NULL,
  id_contexto BIGINT NULL,
  recurso VARCHAR(255) NOT NULL,
  operacao VARCHAR(50) NOT NULL,
  decisao ENUM('permitido', 'negado', 'condicional') NOT NULL,
  motivo TEXT NULL,
  timestamp DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id_decision),
  INDEX idx_auth_decision_identity (id_identity),
  INDEX idx_auth_decision_tenant (id_tenant),
  INDEX idx_auth_decision_session (id_session),
  INDEX idx_auth_decision_timestamp (timestamp)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
```

#### event_stream

```sql
CREATE TABLE event_stream (
  id_evento VARCHAR(255) NOT NULL,
  tipo VARCHAR(255) NOT NULL,
  payload JSON NOT NULL,
  timestamp DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  id_tenant BIGINT NOT NULL,
  id_identity BIGINT NOT NULL,
  id_session BIGINT NULL,
  id_contexto BIGINT NULL,
  correlation_id VARCHAR(255) NULL,
  PRIMARY KEY (id_evento),
  INDEX idx_event_stream_tenant (id_tenant),
  INDEX idx_event_stream_tipo (tipo),
  INDEX idx_event_stream_timestamp (timestamp),
  INDEX idx_event_stream_correlation (correlation_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
```

#### kernel_ledger

```sql
CREATE TABLE kernel_ledger (
  id_ledger BIGINT NOT NULL AUTO_INCREMENT,
  id_evento VARCHAR(255) NOT NULL,
  id_tenant BIGINT NOT NULL,
  id_identity BIGINT NOT NULL,
  id_session BIGINT NULL,
  id_contexto BIGINT NULL,
  timestamp DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  payload JSON NOT NULL,
  imutavel BOOLEAN NOT NULL DEFAULT TRUE,
  PRIMARY KEY (id_ledger),
  INDEX idx_kernel_ledger_tenant (id_tenant),
  INDEX idx_kernel_ledger_timestamp (timestamp),
  INDEX idx_kernel_ledger_evento (id_evento)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
```

### 4.3 Runtime Layer

#### registry_module

```sql
CREATE TABLE registry_module (
  id_module BIGINT NOT NULL AUTO_INCREMENT,
  id_tenant BIGINT NOT NULL,
  nome VARCHAR(255) NOT NULL,
  descricao TEXT NULL,
  versao VARCHAR(50) NOT NULL,
  estado ENUM('rascunho', 'publicado', 'depreciado', 'arquivado', 'removido') NOT NULL DEFAULT 'rascunho',
  criado_em DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  criado_por VARCHAR(255) NOT NULL,
  alterado_em DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  alterado_por VARCHAR(255) NOT NULL,
  PRIMARY KEY (id_module),
  INDEX idx_registry_module_tenant (id_tenant),
  INDEX idx_registry_module_estado (estado)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
```

#### registry_capability

```sql
CREATE TABLE registry_capability (
  id_capability BIGINT NOT NULL AUTO_INCREMENT,
  id_module BIGINT NOT NULL,
  id_tenant BIGINT NOT NULL,
  nome VARCHAR(255) NOT NULL,
  descricao TEXT NULL,
  tipo ENUM('assistencial', 'administrativa', 'tecnica', 'integracao', 'automacao', 'ia', 'utility') NOT NULL,
  estado ENUM('rascunho', 'publicado', 'depreciado', 'arquivado', 'removido', 'composto') NOT NULL DEFAULT 'rascunho',
  composicao JSON NULL,
  criado_em DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  criado_por VARCHAR(255) NOT NULL,
  alterado_em DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  alterado_por VARCHAR(255) NOT NULL,
  PRIMARY KEY (id_capability),
  CONSTRAINT fk_registry_capability_module FOREIGN KEY (id_module) REFERENCES registry_module (id_module),
  INDEX idx_registry_capability_module (id_module),
  INDEX idx_registry_capability_tenant (id_tenant),
  INDEX idx_registry_capability_estado (estado)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
```

#### runtime_execution

```sql
CREATE TABLE runtime_execution (
  id_execution BIGINT NOT NULL AUTO_INCREMENT,
  id_tenant BIGINT NOT NULL,
  id_identity BIGINT NOT NULL,
  id_session BIGINT NULL,
  id_contexto BIGINT NULL,
  id_capability BIGINT NOT NULL,
  estado ENUM('ocioso', 'validando', 'resolvendo', 'executando', 'aguardando', 'compensando', 'sincronizando', 'concluido', 'falhou', 'cancelado') NOT NULL DEFAULT 'ocioso',
  parametros JSON NULL,
  resultado JSON NULL,
  erro JSON NULL,
  iniciado_em DATETIME NULL,
  concluido_em DATETIME NULL,
  PRIMARY KEY (id_execution),
  INDEX idx_runtime_execution_tenant (id_tenant),
  INDEX idx_runtime_execution_identity (id_identity),
  INDEX idx_runtime_execution_capability (id_capability),
  INDEX idx_runtime_execution_estado (estado)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
```

### 4.4 Integration Layer

#### workflow_process

```sql
CREATE TABLE workflow_process (
  id_process BIGINT NOT NULL AUTO_INCREMENT,
  id_tenant BIGINT NOT NULL,
  id_workflow VARCHAR(255) NOT NULL,
  id_identity BIGINT NOT NULL,
  id_contexto BIGINT NULL,
  estado VARCHAR(255) NOT NULL,
  dados JSON NULL,
  criado_em DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  alterado_em DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id_process),
  INDEX idx_workflow_process_tenant (id_tenant),
  INDEX idx_workflow_process_workflow (id_workflow),
  INDEX idx_workflow_process_estado (estado)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
```

#### workflow_state

```sql
CREATE TABLE workflow_state (
  id_state BIGINT NOT NULL AUTO_INCREMENT,
  id_workflow VARCHAR(255) NOT NULL,
  nome VARCHAR(255) NOT NULL,
  descricao TEXT NULL,
  inicial BOOLEAN NOT NULL DEFAULT FALSE,
  final BOOLEAN NOT NULL DEFAULT FALSE,
  PRIMARY KEY (id_state),
  INDEX idx_workflow_state_workflow (id_workflow)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
```

#### workflow_transition

```sql
CREATE TABLE workflow_transition (
  id_transition BIGINT NOT NULL AUTO_INCREMENT,
  id_workflow VARCHAR(255) NOT NULL,
  id_state_origem BIGINT NOT NULL,
  id_state_destino BIGINT NOT NULL,
  nome VARCHAR(255) NOT NULL,
  condicao JSON NULL,
  PRIMARY KEY (id_transition),
  CONSTRAINT fk_workflow_transition_origem FOREIGN KEY (id_state_origem) REFERENCES workflow_state (id_state),
  CONSTRAINT fk_workflow_transition_destino FOREIGN KEY (id_state_destino) REFERENCES workflow_state (id_state),
  INDEX idx_workflow_transition_workflow (id_workflow)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
```

#### integration_registry

```sql
CREATE TABLE integration_registry (
  id_integration BIGINT NOT NULL AUTO_INCREMENT,
  id_tenant BIGINT NOT NULL,
  nome VARCHAR(255) NOT NULL,
  tipo ENUM('api', 'mensageria', 'arquivo', 'webhook', 'etl', 'stream', 'batch') NOT NULL,
  sistema VARCHAR(255) NOT NULL,
  configuracao JSON NOT NULL,
  estado ENUM('ativo', 'inativo', 'erro') NOT NULL DEFAULT 'ativo',
  criado_em DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  criado_por VARCHAR(255) NOT NULL,
  alterado_em DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  alterado_por VARCHAR(255) NOT NULL,
  PRIMARY KEY (id_integration),
  INDEX idx_integration_registry_tenant (id_tenant),
  INDEX idx_integration_registry_sistema (sistema)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
```

---

## 5. Views

### 5.1 Views de leitura

```sql
CREATE VIEW vw_usuario_summary AS
SELECT
  u.id_usuario,
  u.login,
  u.status,
  p.nome_completo,
  p.email,
  p.documento
FROM usuario u
JOIN pessoa p ON u.id_pessoa = p.id_pessoa
WHERE u.excluido_em IS NULL;

CREATE VIEW vw_sessao_ativa AS
SELECT
  s.id_sessao,
  s.id_usuario,
  s.id_tenant,
  s.estado,
  s.expira_em,
  u.login,
  t.nome AS tenant_nome
FROM sessao s
JOIN usuario u ON s.id_usuario = u.id_usuario
JOIN tenant t ON s.id_tenant = t.id_tenant
WHERE s.encerrado_em IS NULL
  AND s.expira_em > NOW();

CREATE VIEW vw_contexto_ativo AS
SELECT
  c.id_contexto,
  c.id_usuario,
  c.id_tenant,
  c.id_sessao,
  c.id_unidade,
  c.id_local,
  c.id_perfil,
  c.ambiente,
  c.runtime,
  c.estado
FROM contexto c
WHERE c.estado = 'ativo';
```

---

## 6. Índices

### 6.1 Índices obrigatórios

```text
Toda tabela de negócio:
  - id_tenant (primeira coluna de índice)
  - chave primária

Tabelas de relacionamento:
  - chaves estrangeiras indexadas

Tabelas de consulta frequente:
  - colunas de filtro indexadas
  - colunas de ordenação indexadas
```

---

## 7. Constraints

### 7.1 Chaves primárias

```text
Toda tabela tem:
  - id_{entidade} BIGINT NOT NULL AUTO_INCREMENT PRIMARY KEY
```

### 7.2 Chaves estrangeiras

```text
Toda FK:
  - Nome: fk_{tabela}_{coluna}
  - Referência: {tabela_pai}({coluna_pai})
  - ON DELETE: RESTRICT
  - ON UPDATE: CASCADE
```

### 7.3 Unique keys

```text
Campos únicos:
  - login (usuario)
  - documento (pessoa, tenant)
  - token (sessao)
  - credencial (identidade_tecnica)
```

---

## 8. Stored Procedures

### 8.1 Tipos

| Tipo | Responsabilidade |
|------|------------------|
| MASTER | Entrada única |
| DISPATCHER | Roteamento |
| ORCHESTRATOR | Coordenação |
| EXECUTOR | Execução |
| ASSERT | Validação |
| QUERY | Consulta |
| COMMAND | Alteração |
| EVENT | Evento |
| LEDGER | Evidência |

### 8.2 Catálogo

Ver: SP-KERNEL-CATALOG.md

---

## 9. Regras de Governança

### 9.1 Criação de tabela

```text
Nova tabela:
1. Verificar se já existe tabela equivalente
2. Se existir: reutilizar
3. Se não existir: criar com id_tenant
4. Documentar em MODEL-PHYSICAL-KERNEL.md
5. Aprovar
6. Gerar SQL
```

### 9.2 Alteração de tabela

```text
Alterar tabela:
1. Avaliar impacto
2. Criar migração
3. Testar
4. Aprovar
5. Executar
```

### 9.3 Exclusão de tabela

```text
Excluir tabela:
1. Verificar dependências
2. Migrar dados
3. Marcar como deprecated
4. Remover após período
```

---

## 10. Próximos Artefatos

| Prioridade | Artefato | Descrição |
|------------|----------|-----------|
| Alta | SP-KERNEL-CATALOG.md | Catálogo de procedures |

---

## 11. Referências

- MD-KERNEL-000 — Arquitetura Conceitual do Kernel Enterprise
- MD-KERNEL-001 até MD-KERNEL-014
- MAP-CORE-PLATFORM
- BR-CATALOG
- MAP-RUNTIME-FLOW
- MAP-DATA-CANONICAL
- REVIEW-KERNEL-TRANSVERSAL
- MODEL-LOGICAL-KERNEL
- MAPA DO KERNEL ENTERPRISE
- MD-KERNEL-DEPENDENCY-MAP
- MD-110 — Canonical Laws
- MD-113 — Lei da Singularidade Canônica
- 000-CONSTITUICAO-IA.md

---

## 12. Histórico

| Versão | Data | Autor | Descrição |
|--------|------|-------|-----------|
| 1.0 | 2026-07-13 | Kilo | Criação do modelo físico |

---

Documento Canônico — MODEL-PHYSICAL-KERNEL

**Este é o documento oficial de modelo físico do Kernel da plataforma New Wave Enterprise.**
