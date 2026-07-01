# auditoria_mestre

Objetivo: Manter registro master de todas as alterações em tabelas do sistema com valores anteriores e novos.
Descrição: Tabela de auditoria master que registra qualquer alteração em registros do sistema, capturando o valor anterior, valor novo, tabela afetada e motivo da alteração, permitindo auditoria completa de mudanças.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|--------|------|----------|---------|------------------|
| id | bigint | NOT NULL | - | Identificador único do registro, chave primária auto incrementada. |
| id_sessao_usuario | bigint | NOT NULL | - | Referência à sessão do usuário que realizou a alteração. |
| dominio | enum('FILA','ASSISTENCIAL','FINANCEIRO','ESTOQUE') | Nullable | - | Domínio da tabela afetada pela alteração. |
| acao | varchar(100) | Nullable | - | Tipo de ação realizada (INSERT, UPDATE, DELETE). |
| tabela_afetada | varchar(100) | Nullable | - | Nome da tabela onde a alteração ocorreu. |
| id_registro | bigint | Nullable | - | Identificador do registro afetado na tabela. |
| valor_anterior | json | Nullable | - | Valor anterior do registro em formato JSON. |
| valor_novo | json | Nullable | - | Valor novo do registro em formato JSON. |
| motivo_alteracao | text | Nullable | - | Justificativa ou motivo da alteração realizada. |
| data_evento | datetime | Nullable | CURRENT_TIMESTAMP | Data e hora do evento de alteração. |
| id_entidade | bigint unsigned | NOT NULL | - | Referência à entidade (organização) à qual o registro pertence. |

## Chaves
- Primária: id
- Únicas: nenhuma
- Estrangeiras:
  - fk_audit_sessao_usuario: id_sessao_usuario → sessao_usuario (id_sessao_usuario)

## Índices
- PRIMARY KEY (id)
- KEY fk_audit_sessao_usuario (id_sessao_usuario)

## Constraints
- PRIMARY KEY: id
- FOREIGN KEY: fk_audit_sessao_usuario (id_sessao_usuario) REFERENCES sessao_usuario (id_sessao_usuario)

## Relacionamentos e Cardinalidade
- N:1 com sessao_usuario (id_sessao_usuario)
- N:1 com saas_entidade (id_entidade)

## Dependências
- Tabelas que dependem desta: nenhuma
- Dependência desta tabela: sessao_usuario, saas_entidade

## Fluxo de utilização dentro do sistema
- Registrada automaticamente em operações de alteração de dados
- Permite auditoria completa com valores antigos e novos
- Usada para rastrear mudanças em qualquer domínio do sistema
- Suporta reconstrução de estado anterior em caso de rollback