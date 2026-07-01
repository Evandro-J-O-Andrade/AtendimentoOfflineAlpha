# atendimento_sinais_vitais

Objetivo: Registrar sinais vitais do paciente durante atendimentos, controlando pressão arterial, frequências cardíaca e respiratória, temperatura, saturação e glicemia.

Descrição: Esta tabela armazena os sinais vitais medidos durante atendimentos médicos, permitindo o acompanhamento contínuo da saúde do paciente com todos os parâmetros críticos incluindo pressão sistólica e diastólica, frequência cardíaca, respiratória, temperatura, saturação de O2 e HGT (glicemia).

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|---------|------|----------|---------|------------------|
| id | bigint | NOT NULL | AUTO_INCREMENT | Identificador único do registro de sinais vitais |
| id_atendimento | bigint unsigned | NOT NULL | - | Chave estrangeira que referencia o atendimento ao qual os sinais pertencem |
| id_usuario_registro | bigint | NOT NULL | - | Identificador do usuário que registrou os sinais vitais |
| pa_sistolica | int | YES | NULL | Pressão arterial sistólica em mmHg (máxima) |
| pa_diastolica | int | YES | NULL | Pressão arterial diastólica em mmHg (mínima) |
| frequencia_cardiaca | int | YES | NULL | Frequência cardíaca em batimentos por minuto (bpm) |
| frequencia_respiratoria | int | YES | NULL | Frequência respiratória em respirações por minuto |
| temperatura | decimal(4,1) | YES | NULL | Temperatura corporal em graus Celsius (ex: 36.5) |
| saturacao_o2 | int | YES | NULL | Saturação de oxigênio no sangue em percentual (SpO2) |
| hgt | int | YES | NULL | HGT (Hemoglicotesto) - glicemia em mg/dL |
| data_registro | datetime | YES | CURRENT_TIMESTAMP | Timestamp automático da data/hora do registro dos sinais |
| id_entidade | bigint unsigned | NOT NULL | - | Identificador da entidade (organização/unidade) à qual o registro pertence |

## Chaves
- Primária: id
- Únicas: Nenhuma
- Estrangeiras: fk_sv_atendimento - id_atendimento → atendimento(id_atendimento) - Vincula os sinais ao atendimento; fk_atendimento_sinais_vitais_atendimento - id_atendimento → atendimento(id_atendimento) - Vincula os sinais ao atendimento; fk_atendimento_sinais_vitais_entidade - id_entidade → saas_entidade(id_entidade) - Vincula os sinais à entidade |

## Índices
- fk_sv_atendimento (KEY) - Índice para busca por atendimento
- idx_asv_ent (KEY) - Índice para busca por entidade

## Constraints
- fk_atendimento_sinais_vitais_atendimento - FOREIGN KEY - Restringe id_atendimento à tabela atendimento(id_atendimento) com CASCADE
- fk_atendimento_sinais_vitais_entidade - FOREIGN KEY - Restringe id_entidade à tabela saas_entidade(id_entidade)

## Relacionamentos e Cardinalidade
- N:1 com atendimento - Cada registro de sinais vitais está associado a um atendimento
- N:1 com saas_entidade - Cada registro pertence a uma entidade SaaS
- N:1 com usuario - Cada registro é feito por um usuário

## Dependências
- Tabelas que dependem desta: Nenhuma (não há FK apontando para atendimento_sinais_vitais)
- Tabelas das quais esta depende: atendimento, saas_entidade, usuario

## Fluxo de utilização dentro do sistema
- Registro periódico de sinais vitais durante atendimento
- Pressão arterial sistólica e diastólica separadas para controle individual
- Frequência cardíaca e respiratória para monitoramento cardiorrespiratório
- Temperatura com precisão de 1 decimal para detecção de febre
- Saturação de O2 para monitoramento de oxigenação
- HGT (glicemia) para controle de diabetes
- Timestamp automático para auditoria de quando foi medido
- Múltiplos registros por atendimento para acompanhamento temporal
- Cascade delete remove sinais quando atendimento é excluído