# internacao_movimentacao

Objetivo: Registrar movimentações de pacientes entre leitos durante internação.

Descrição: Tabela que controla as transferências de pacientes entre leitos durante a internação, registrando origem, destino, responsável e motivo da movimentação. Utilizada para histórico de locomoção do paciente.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|---------|------|----------|---------|------------------|
| id | bigint | NOT NULL | - | Identificador único da movimentação, chave primária auto incrementada |
| id_internacao | bigint | NOT NULL | - | Referência à internação que sofreu a movimentação |
| id_leito_origem | bigint | DEFAULT NULL | - | Referência ao leito de origem (onde estava) |
| id_leito_destino | bigint | NOT NULL | - | Referência ao leito de destino (para onde foi) |
| id_usuario_transferencia | bigint | NOT NULL | - | Referência ao usuário que realizou a transferência |
| data_movimentacao | datetime | DEFAULT CURRENT_TIMESTAMP | - | Data e hora da movimentação |
| motivo | varchar(255) | DEFAULT NULL | - | Motivo da transferência entre leitos |
| id_sessao_usuario | bigint | DEFAULT NULL | - | Referência à sessão do usuário que transferiu |
| id_local_operacional | bigint | DEFAULT NULL | - | Referência ao local operacional |
| id_unidade | bigint unsigned | NOT NULL | - | Referência à unidade envolvida |
| id_atendimento | bigint unsigned | NOT NULL | - | Referência ao atendimento principal |
| id_entidade | bigint unsigned | NOT NULL | - | Referência à entidade (organização) associada |

## Chaves
- Primária: id
- Únicas: -
- Estrangeiras: fk_internacao_movimentacao_atendimento (id_atendimento → atendimento.id_atendimento ON DELETE CASCADE ON UPDATE CASCADE); fk_internacao_movimentacao_unidade (id_unidade → unidade.id_unidade); fk_mov_internacao (id_internacao → internacao.id_internacao)

## Índices
- fk_mov_internacao (id_internacao)
- idx_intern_mov_internacao_data (id_internacao, data_movimentacao)
- idx_mov_sessao_data (id_sessao_usuario, data_movimentacao)
- fk_internacao_movimentacao_unidade (id_unidade)
- fk_internacao_movimentacao_atendimento (id_atendimento)
- idx_int_mov_ent (id_entidade)

## Constraints
- CONSTRAINT fk_internacao_movimentacao_atendimento FOREIGN KEY (id_atendimento) REFERENCES atendimento (id_atendimento) ON DELETE CASCADE ON UPDATE CASCADE
- CONSTRAINT fk_internacao_movimentacao_entidade FOREIGN KEY (id_entidade) REFERENCES saas_entidade (id_entidade)
- CONSTRAINT fk_internacao_movimentacao_unidade FOREIGN KEY (id_unidade) REFERENCES unidade (id_unidade)
- CONSTRAINT fk_mov_internacao FOREIGN KEY (id_internacao) REFERENCES internacao (id_internacao)

## Relacionamentos e Cardinalidade
- internacao_movimentacao.id_internacao → internacao (id_internacao): N:1
- internacao_movimentacao.id_atendimento → atendimento (id_atendimento): N:1
- internacao_movimentacao.id_usuario_transferencia → usuario (id_usuario): N:1

## Dependências
- Tabelas que dependem desta: -
- Esta tabela depende de: internacao, atendimento, unidade, saas_entidade, usuario

## Fluxo de utilização dentro do sistema
1. Paciente em internação precisa ser transferido
2. id_leito_origem e id_leito_destino registram a mudança
3. motivo explica a razão da transferência
4. Histórico é mantido para rastrear todas as movimentações
5. ON DELETE CASCADE remove registros se atendimento for excluído