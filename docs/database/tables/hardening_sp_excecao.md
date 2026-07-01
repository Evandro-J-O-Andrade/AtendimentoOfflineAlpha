# hardening_sp_excecao

Objetivo: Registrar exceções a regras de hardening de stored procedures.

Descrição: Tabela que lista as stored procedures que possuem exceções às regras de segurança (hardening), permitindo execução mesmo quando outras estariam bloqueadas. Utilizada para controle de segurança no banco de dados.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|---------|------|----------|---------|------------------|
| sp_nome | varchar(128) | NOT NULL | - | Nome da stored procedure que possui exceção (chave primária) |
| motivo | varchar(255) | DEFAULT NULL | - | Motivo da exceção - justificativa para o bloqueio ser ignorado |
| criado_em | datetime | NOT NULL DEFAULT | CURRENT_TIMESTAMP | Data e hora de criação do registro |
| id_entidade | bigint unsigned | NOT NULL | - | Referência à entidade (organização) associada |

## Chaves
- Primária: sp_nome
- Únicas: -
- Estrangeiras: -

## Índices
- -

## Constraints
- -

## Relacionamentos e Cardinalidade
- hardening_sp_excecao é uma tabela de configuração isolada, sem relacionamentos

## Dependências
- Tabelas que dependem desta: -
- Esta tabela depende de: -

## Fluxo de utilização dentro do sistema
1. Stored procedures são cadastradas com suas exceções
2. motivo documenta o porquê da exceção
3. Sistema de hardening verifica esta tabela antes de bloquear SPs
4. Permite execução de procedimentos críticos mesmo com hardening ativo