# atendimento_balanco_hidrico

Objetivo: Registrar o balanço hídrico do paciente durante atendimentos, controlando entradas e saídas de fluidos e volume administrado.

Descrição: Esta tabela controla o balanço hídrico do paciente durante atendimentos, registrando o tipo de movimentação (entrada/saída), via de administração, volume em mililitros e auditoria completa do registro.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|---------|------|----------|---------|------------------|
| id | bigint | NOT NULL | AUTO_INCREMENT | Identificador único do registro de balanço hídrico |
| id_atendimento | bigint unsigned | NOT NULL | - | Chave estrangeira que referencia o atendimento ao qual o balanço pertence |
| tipo_movimentacao | enum('ENTRADA','SAIDA') | YES | NULL | Tipo de movimentação hídrica: ENTRADA (fluido administrado) ou SAÍDA (evacuação) |
| via | varchar(50) | YES | NULL | Via de administração ou tipo de saída (oral, venosa, urina, etc.) |
| volume_ml | int | NOT NULL | - | Volume em mililitros da movimentação hídrica registrada |
| id_usuario_registro | bigint | NOT NULL | - | Identificador do usuário que registrou o balanço hídrico |
| data_hora | datetime | YES | CURRENT_TIMESTAMP | Timestamp automático da data/hora do registro |
| id_entidade | bigint unsigned | NOT NULL | - | Identificador da entidade (organização/unidade) à qual o registro pertence |

## Chaves
- Primária: id
- Únicas: Nenhuma
- Estrangeiras: fk_atendimento_balanco_hidrico_atendimento - id_atendimento → atendimento(id_atendimento) - Vincula o balanço ao atendimento; fk_atendimento_balanco_hidrico_entidade - id_entidade → saas_entidade(id_entidade) - Vincula o balanço à entidade; fk_balanco_atend - id_atendimento → atendimento(id_atendimento) - Vincula o balanço ao atendimento; fk_balanco_atendimento - id_atendimento → atendimento(id_atendimento) - Vincula o balanço ao atendimento (constraint duplicada) |

## Índices
- fk_atendimento_balanco_hidrico_atendimento (KEY) - Índice para busca por atendimento
- idx_abhi_ent (KEY) - Índice para busca por entidade

## Constraints
- fk_atendimento_balanco_hidrico_atendimento - FOREIGN KEY - Restringe id_atendimento à tabela atendimento(id_atendimento) com CASCADE
- fk_atendimento_balanco_hidrico_entidade - FOREIGN KEY - Restringe id_entidade à tabela saas_entidade(id_entidade)
- fk_balanco_atend - FOREIGN KEY - Restringe id_atendimento à tabela atendimento(id_atendimento) com RESTRICT
- fk_balanco_atendimento - FOREIGN KEY - Restringe id_atendimento à tabela atendimento(id_atendimento)

## Relacionamentos e Cardinalidade
- N:1 com atendimento - Cada registro de balanço hídrico está associado a um atendimento (várias constraints)
- N:1 com saas_entidade - Cada balanço pertence a uma entidade SaaS
- N:1 com usuario - Cada registro é feito por um usuário

## Dependências
- Tabelas que dependem desta: Nenhuma (não há FK apontando para atendimento_balanco_hidrico)
- Tabelas das quais esta depende: atendimento, saas_entidade, usuario

## Fluxo de utilização dentro do sistema
- Registro de entradas e saídas de fluidos no atendimento
- Controle de volume em mililitros para gestão hídrica do paciente
- Auditoria completa com usuário e timestamp de registro
- Vinculação ao atendimento para contexto clínico
- Múltiplas constraints FK apontando para atendimento (arquitetura redundante para integridade)
- Índice para busca eficiente por atendimento