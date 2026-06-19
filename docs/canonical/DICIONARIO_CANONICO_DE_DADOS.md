# DICIONARIO_CANONICO_DE_DADOS.md

## Tabela: pessoa

| Campo | Tipo | Obrigatório | FK | Índice |
|-------|------|-------------|-----|--------|
| id_pessoa | BIGINT PK | Sim | - | PK |
| nome | VARCHAR(200) | Sim | - | idx_pessoa_nome |
| data_nascimento | DATE | Sim | - | idx_pessoa_data_nasc |
| sexo | CHAR(1) | Sim | - | - |
| cpf | VARCHAR(14) | Sim | - | UK |
| rg | VARCHAR(20) | Não | - | - |
| telefone | VARCHAR(20) | Não | - | - |
| email | VARCHAR(100) | Não | - | - |

## Tabela: usuario

| Campo | Tipo | Obrigatório | FK | Índice |
|-------|------|-------------|-----|--------|
| id_usuario | BIGINT PK | Sim | id_pessoa | PK |
| login | VARCHAR(50) | Sim | - | UK |
| senha_hash | VARCHAR(255) | Sim | - | - |
| ativo | BOOLEAN | Sim | - | - |

## Tabela: senha

| Campo | Tipo | Obrigatório | FK | Índice |
|-------|------|-------------|-----|--------|
| id_senha | BIGINT PK | Sim | id_pessoa, id_unidade | PK |
| numero | VARCHAR(20) | Sim | - | UK |
| prioridade | INT | Sim | - | idx_senha_prioridade |
| status | VARCHAR(20) | Sim | - | - |

## Tabela: ffa

| Campo | Tipo | Obrigatório | FK | Índice |
|-------|------|-------------|-----|--------|
| id_ffa | BIGINT PK | Sim | id_senha | PK |
| id_unidade | BIGINT | Sim | - | idx_ffa_unidade |
| status | VARCHAR(20) | Sim | - | - |

## Tabela: gpat

| Campo | Tipo | Obrigatório | FK | Índice |
|-------|------|-------------|-----|--------|
| id_gpat | BIGINT PK | Sim | id_ffa | PK |
| codigo | VARCHAR(30) | Sim | - | UK |
| status | VARCHAR(20) | Sim | - | - |