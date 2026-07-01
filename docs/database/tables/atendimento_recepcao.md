# atendimento_recepcao

Objetivo: Registrar informações de recepção do atendimento, controlando tipo, modo de chegada, prioridade e destino inicial do paciente.

Descrição: Esta tabela armazena os dados de recepção do paciente no início do atendimento, incluindo tipo de atendimento (clínico, pediátrico, emergência, exame externo, medicação externa), modo de chegada (meios próprios, ambulância, polícia, outros), prioridade e motivo da procura.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|---------|------|----------|---------|------------------|
| id_atendimento | bigint unsigned | NOT NULL | - | Identificador do atendimento - também é a chave primária (1:1 com atendimento) |
| tipo_atendimento | enum('CLINICO','PEDIATRICO','EMERGENCIA','EXAME_EXTERNO','MEDICACAO_EXTERNA') | NOT NULL | - | Tipo de atendimento na recepção: clínico, pediátrico, emergência, exame externo ou medicação externa |
| chegada | enum('MEIOS_PROPRIOS','AMBULANCIA','POLICIA','OUTROS') | NOT NULL | - | Modo de chegada do paciente: meios próprios, ambulância, polícia ou outros |
| prioridade | enum('AUTISTA','CRIANCA_COLO','GESTANTE','IDOSO','NORMAL') | YES | 'NORMAL' | Classificação de prioridade na fila: autista, criança no colo, gestante, idoso, normal |
| motivo_procura | text | YES | NULL | Motivo da procura pelo atendimento médico |
| destino_inicial | enum('TRIAGEM','MEDICO','EMERGENCIA','RX','MEDICACAO') | NOT NULL | - | Destino inicial do paciente após recepção: triagem, médico, emergência, RX ou medicação |
| id_recepcionista | bigint | NOT NULL | - | Identificador do usuário recepcionista que registrou o atendimento |
| data_hora | datetime | YES | CURRENT_TIMESTAMP | Timestamp automático da data/hora do registro na recepção |
| id_entidade | bigint unsigned | NOT NULL | - | Identificador da entidade (organização/unidade) à qual o registro pertence |

## Chaves
- Primária: id_atendimento
- Únicas: Nenhuma
- Estrangeiras: atendimento_recepcao_ibfk_2 - id_recepcionista → usuario(id_usuario) - Vincula o registro ao recepcionista; fk_atendimento_recepcao_atendimento - id_atendimento → atendimento(id_atendimento) - Vincula o registro ao atendimento; fk_atendimento_recepcao_entidade - id_entidade → saas_entidade(id_entidade) - Vincula o registro à entidade |

## Índices
- id_recepcionista (KEY) - Índice para busca por recepcionista
- idx_arec_ent (KEY) - Índice para busca por entidade

## Constraints
- atendimento_recepcao_ibfk_2 - FOREIGN KEY - Restringe id_recepcionista à tabela usuario(id_usuario)
- fk_atendimento_recepcao_atendimento - FOREIGN KEY - Restringe id_atendimento à tabela atendimento(id_atendimento) com CASCADE
- fk_atendimento_recepcao_entidade - FOREIGN KEY - Restringe id_entidade à tabela saas_entidade(id_entidade)

## Relacionamentos e Cardinalidade
- 1:1 com atendimento - Cada atendimento tem um registro de recepção único
- N:1 com usuario - Cada registro é feito por um recepcionista
- N:1 com saas_entidade - Cada registro pertence a uma entidade SaaS

## Dependências
- Tabelas que dependem desta: Nenhuma (não há FK apontando para atendimento_recepcao)
- Tabelas das quais esta depende: atendimento, usuario, saas_entidade

## Fluxo de utilização dentro do sistema
- Registro na recepção quando o paciente inicia o atendimento
- Classificação de prioridade para gestão de filas
- Destino inicial para direcionamento ao setor correto (triagem, médico, emergência)
- Modo de chegada para estatísticas e protocolos de atendimento
- Vinculação ao recepcionista para auditoria
- Cascade delete remove registro quando atendimento é excluído