# plantao_escala

Objetivo: Registrar escalas de plantão por data e turno.
Descrição: Tabela que define a escala semanal de plantões, associando funcionários a datas, turnos e modelos de plantão.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|--------|------|----------|---------|------------------|
| id_plantao_escala | bigint | NOT NULL | - | Identificador único da escala (chave primária, auto incremento) |
| id_unidade | bigint unsigned | NOT NULL | - | ID da unidade onde o plantão está escalado |
| id_funcionario | bigint | NOT NULL | - | ID do funcionário escalado para o plantão |
| data | date | NOT NULL | - | Data do plantão escalado |
| turno | varchar(30) | NOT NULL | - | Turno do plantão (ex: "MANHA", "TARDE", "NOITE", "PLANTAO") |
| hora_inicio | time | YES | NULL | Hora de início do turno |
| hora_fim | time | YES | NULL | Hora de fim do turno |
| id_plantao_modelo | bigint | YES | NULL | ID do modelo de plantão (opcional, para herdar configurações) |
| tipo_plantao | enum('CLINICO','PEDIATRIA','EMERGENCIA','ADMINISTRATIVO','OUTRO') | YES | NULL | Tipo de plantão (pode ser herdados do modelo) |
| ativo | tinyint(1) | YES | '1' | Flag indicando se a escala está ativa |
| criado_em | datetime(6) | YES | CURRENT_TIMESTAMP(6) | Data/hora de criação do registro |
| atualizado_em | datetime(6) | YES | NULL ON UPDATE CURRENT_TIMESTAMP(6) | Data/hora da última atualização |
| id_entidade | bigint unsigned | NOT NULL | - | ID da entidade/tenant à qual a escala pertence |

## Chaves
- Primária: id_plantao_escala
- Únicas: uk_plantao_escala_global (id_unidade, id_funcionario, data, turno)
- Estrangeiras: 
  - fk_plantao_escala_funcionario: id_funcionario → funcionario (id_funcionario) com RESTRICT
  - fk_plantao_escala_modelo: id_plantao_modelo → plantao_modelo (id_plantao_modelo) com SET NULL
  - fk_plantao_escala_unidade: id_unidade → unidade (id_unidade)

## Índices
- PRIMARY KEY (id_plantao_escala)
- UNIQUE KEY uk_plantao_escala_global (id_unidade, id_funcionario, data, turno)
- KEY idx_pe_unidade_data (id_unidade, data)
- KEY idx_pe_funcionario (id_funcionario)
- KEY fk_plantao_escala_modelo (id_plantao_modelo)

## Constraints
- PRIMARY KEY: id_plantao_escala
- UNIQUE: uk_plantao_escala_global
- FOREIGN KEY: fk_plantao_escala_funcionario
- FOREIGN KEY: fk_plantao_escala_modelo
- FOREIGN KEY: fk_plantao_escala_unidade

## Relacionamentos e Cardinalidade
- N:1 com unidade: Muitas escalas pertencem a uma unidade
- N:1 com funcionario: Muitas escalas são para um funcionário
- N:1 com plantao_modelo: Muitas escalas podem referenciar um modelo

## Dependências
- Esta tabela depende de: unidade, funcionario, plantao_modelo, saas_entidade
- Não há tabelas que dependem desta tabela

## Fluxo de utilização dentro do sistema
Utilizada para criar e manter escalas de plantão. O modelo (plantao_modelo) define os horários padrão, enquanto esta tabela especifica quem trabalha em cada data. Permite evitar duplicação de escalas (via uk_plantao_escala_global) e saber antecipadamente quem estará de plantão. Integra-se ao módulo de agendamentos para verificar disponibilidade.