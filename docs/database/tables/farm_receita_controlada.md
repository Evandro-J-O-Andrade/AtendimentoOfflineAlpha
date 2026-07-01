# farm_receita_controlada

Objetivo: Controle de receitas médicas e prescrições

Descrição: Receita médica controlada para dispensação de medicamentos, vinculada a operação de farmácia e podendo ser de origem interna ou externa.

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao/Descricao |
|---------|------|----------|---------|------------------|
| id_receita | bigint AUTO_INCREMENT | NO | — | Identificador da receita médica |
| id_operacao | bigint | NO | — | Identificador da operação de farmácia |
| origem | enum('INTERNO','EXTERNO') | NO | — | Origem do registro (sistema ou operação que gerou o evento) |
| id_prescricao_medicacao | bigint DEFAULT | YES | NULL | Identificador único de prescricao medicacao |
| id_atendimento_ext | bigint DEFAULT | YES | NULL | Identificador do atendimento |
| paciente_nome | varchar(255) DEFAULT | YES | NULL | Nome completo do paciente |
| paciente_documento | varchar(40) DEFAULT | YES | NULL | Documento de identificação do paciente |
| id_medico | bigint DEFAULT | YES | NULL | Identificador único de medico |
| id_prescritor_externo | bigint DEFAULT | YES | NULL | Identificador único de prescritor externo |
| numero_receita | varchar(80) DEFAULT | YES | NULL | Número sequencial do documento |
| status | enum('PENDENTE','RECEBIDA','DISPENSADA','CANCELADA') | NO | 'PENDENTE' | Status atual conforme enumeração definida |
| recebido_em | datetime DEFAULT | YES | NULL | Data e hora do registro |
| id_usuario_recebimento | bigint DEFAULT | YES | NULL | Identificador único de usuario recebimento |
| id_usuario_baixa_final | bigint DEFAULT | YES | NULL | Usuário responsável pela baixa final |
| baixa_final_em | datetime DEFAULT | YES | NULL | Usuário responsável pela baixa final |
| criado_em | datetime | NO | CURRENT_TIMESTAMP | Data e hora do registro |
| id_entidade | bigint unsigned | NO | — | Identificador da entidade multitenant |

## Chaves

- Primaria: id_receita
- Estrangeira (fk_rc_at_ext): coluna id_atendimento_ext -> tabela farm_atendimento_externo(id_atendimento_ext): Referencia a tabela farm_atendimento_externo (coluna id_atendimento_ext) para garantir integridade referencial
- Estrangeira (fk_rc_operacao): coluna id_operacao -> tabela farm_operacao(id_operacao): Referencia a tabela farm_operacao (coluna id_operacao) para garantir integridade referencial

## Indices

- ix_receita_status (status)
- fk_rc_operacao (id_operacao)
- fk_rc_at_ext (id_atendimento_ext)

## Constraints

- FOREIGN KEY fk_rc_at_ext: id_atendimento_ext references farm_atendimento_externo(id_atendimento_ext)
- FOREIGN KEY fk_rc_operacao: id_operacao references farm_operacao(id_operacao)
- PRIMARY KEY (id_receita)

## Relacionamentos e Cardinalidade

- farm_receita_controlada (1) -> farm_atendimento_externo (1): campo id_atendimento_ext
- farm_receita_controlada (1) -> farm_operacao (1): campo id_operacao

## Dependencias

- Depende de:
  - farm_atendimento_externo
  - farm_operacao
- Dependencias diretas: Nenhuma tabela listada depende diretamente desta tabela com base nas FKs encontradas.

## Fluxo de utilizacao dentro do sistema

- Receita médica controlada para dispensação de medicamentos.
- Vinculada a operação de farmácia (HIS, PA, UPA, etc.).
- Pode ser criada internamente ou originada de atendimento externo.
- Segue fluxo de recebimento, primeira baixa e segunda baixa até finalização.
