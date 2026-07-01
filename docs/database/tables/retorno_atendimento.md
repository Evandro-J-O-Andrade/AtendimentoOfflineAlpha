# retorno_atendimento

Objetivo: Registrar relações de retorno entre atendimentos, permitindo acompanhar pacientes que retornam para novos atendimentos.

Descrição: Tabela que vincula atendimentos de retorno a atendimentos origem, permitindo acompanhar pacientes que retornam para continuidade do tratamento ou acompanhamento.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|--------|------|----------|---------|------------------|
| id_retorno | bigint | NOT NULL | - | Chave primária da tabela, identificador único do retorno |
| id_atendimento_origem | bigint unsigned | NOT NULL | - | Referência ao id do atendimento original que gerou o retorno |
| id_atendimento_retorno | bigint unsigned | NOT NULL | - | Referência ao id do atendimento de retorno |
| motivo | text | YES | NULL | Motivo do retorno para novo atendimento |
| data_hora | datetime | - | CURRENT_TIMESTAMP | Data e hora do registro do retorno |
| id_atendimento | bigint unsigned | NOT NULL | - | Referência ao id do atendimento pai (pode ser o origem ou retorno) |
| id_entidade | bigint unsigned | NOT NULL | - | Identificador da entidade/organização onde o retorno foi registrado |

## Chaves
- Primária: id_retorno
- Únicas: -
- Estrangeiras: fk_retorno_atendimento_atendimento (id_atendimento → atendimento.id_atendimento) - vincula ao atendimento; fk_retorno_atendimento_entidade (id_entidade → saas_entidade.id_entidade) - vincula à entidade

## Índices
- PRIMARY KEY (id_retorno)
- KEY id_atendimento_origem (id_atendimento_origem)
- KEY id_atendimento_retorno (id_atendimento_retorno)
- KEY fk_retorno_atendimento_atendimento (id_atendimento)
- KEY idx_ret_ent (id_entidade)

## Constraints
- CONSTRAINT fk_retorno_atendimento_atendimento FOREIGN KEY (id_atendimento) REFERENCES atendimento (id_atendimento) ON DELETE CASCADE ON UPDATE CASCADE
- CONSTRAINT fk_retorno_atendimento_entidade FOREIGN KEY (id_entidade) REFERENCES saas_entidade (id_entidade)

## Relacionamentos e Cardinalidade
- N:1 com atendimento (um atendimento pode ter vários retornos vinculados)
- 1:1 com atendimento (relacionamento autorreferencial entre atendimentos origem e retorno)

## Dependências
- Tabelas que dependem desta: -
| Esta tabela depende de: atendimento, saas_entidade

## Fluxo de utilização dentro do sistema
- Criado quando um paciente retorna para novo atendimento
- Vincula o atendimento de retorno ao atendimento original
- Permite acompanhamento de casos recorrentes
- Motivo ajuda a entender a necessidade do retorno