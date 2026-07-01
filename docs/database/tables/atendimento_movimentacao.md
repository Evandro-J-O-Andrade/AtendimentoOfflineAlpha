# atendimento_movimentacao

Objetivo: Registrar movimentações de atendimento entre locais, permitindo o acompanhamento do deslocamento do paciente dentro da unidade.

Descrição: Esta tabela controla as movimentações de atendimento entre locais operacionais, registrando o local de origem, destino, usuário responsável, motivo e timestamp da movimentação para auditoria e rastreamento.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|---------|------|----------|---------|------------------|
| id_mov | bigint | NOT NULL | AUTO_INCREMENT | Identificador único do registro de movimentação |
| id_atendimento | bigint unsigned | NOT NULL | - | Chave estrangeira que referencia o atendimento ao qual a movimentação pertence |
| de_local | int | YES | NULL | Identificador do local de origem da movimentação |
| para_local | int | YES | NULL | Identificador do local de destino da movimentação |
| id_usuario | bigint | YES | NULL | Identificador do usuário responsável pela movimentação |
| motivo | varchar(255) | YES | NULL | Motivo ou justificativa da movimentação |
| data_hora | datetime | YES | CURRENT_TIMESTAMP | Timestamp automático da data/hora da movimentação |
| id_entidade | bigint unsigned | NOT NULL | - | Identificador da entidade (organização/unidade) à qual o registro pertence |

## Chaves
- Primária: id_mov
- Únicas: Nenhuma
- Estrangeiras: atendimento_movimentacao_ibfk_2 - id_usuario → usuario(id_usuario) - Vincula a movimentação ao usuário; fk_atendimento_movimentacao_atendimento - id_atendimento → atendimento(id_atendimento) - Vincula a movimentação ao atendimento; fk_atendimento_movimentacao_entidade - id_entidade → saas_entidade(id_entidade) - Vincula a movimentação à entidade |

## Índices
- id_atendimento (KEY) - Índice para busca por atendimento
- id_usuario (KEY) - Índice para busca por usuário
- idx_amov_ent (KEY) - Índice para busca por entidade

## Constraints
- atendimento_movimentacao_ibfk_2 - FOREIGN KEY - Restringe id_usuario à tabela usuario(id_usuario)
- fk_atendimento_movimentacao_atendimento - FOREIGN KEY - Restringe id_atendimento à tabela atendimento(id_atendimento) com CASCADE
- fk_atendimento_movimentacao_entidade - FOREIGN KEY - Restringe id_entidade à tabela saas_entidade(id_entidade)

## Relacionamentos e Cardinalidade
- N:1 com atendimento - Cada movimentação está associada a um atendimento (com CASCADE)
- N:1 com usuario - Cada movimentação pode ter um usuário responsável (opcional)
- N:1 com saas_entidade - Cada movimentação pertence a uma entidade SaaS

## Dependências
- Tabelas que dependem desta: Nenhuma (não há FK apontando para atendimento_movimentacao)
- Tabelas das quais esta depende: atendimento, usuario, saas_entidade

## Fluxo de utilização dentro do sistema
- Registro de deslocamento do paciente entre locais durante atendimento
- Local de origem e destino para acompanhamento do fluxo
- Vinculação ao usuário responsável pela movimentação
- Motivo da movimentação para justificativa clínica ou administrativa
- Timestamp automático para auditoria de quando ocorreu
- Índices para busca eficiente por atendimento e usuário
- Cascade delete remove movimentações quando atendimento é excluído