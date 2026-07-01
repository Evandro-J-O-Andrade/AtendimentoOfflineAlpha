# funcionario_unidade

Objetivo: Vincular funcionários às unidades onde atuam.

Descrição: Tabela que associa funcionários às unidades do hospital e define suas funções específicas em cada unidade. Controla período de atuação (data_inicio, data_fim) e se ainda está ativo naquela unidade.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|---------|------|----------|---------|------------------|
| id_funcionario_unidade | bigint | NOT NULL | - | Identificador único da associação, chave primária auto incrementada |
| id_funcionario | bigint | NOT NULL | - | Referência ao funcionário ao qual a unidade está vinculada |
| id_unidade | bigint unsigned | NOT NULL | - | Referência à unidade onde o funcionário atua |
| funcao_unidade | varchar(150) | DEFAULT NULL | - | Função específica do funcionário na unidade (ex: MEDICO_PLANTONISTA) |
| data_inicio | date | DEFAULT NULL | - | Data de início da atuação na unidade |
| data_fim | date | DEFAULT NULL | - | Data de fim da atuação na unidade (se aplicável) |
| ativo | tinyint(1) | DEFAULT | '1' | Indicador se o funcionário está ativo na unidade |
| criado_em | datetime(6) | DEFAULT | CURRENT_TIMESTAMP(6) | Data e hora de criação do registro |
| atualizado_em | datetime(6) | DEFAULT NULL ON UPDATE | CURRENT_TIMESTAMP(6) | Data e hora da última atualização |
| id_entidade | bigint unsigned | DEFAULT NULL | - | Referência à entidade (organização) associada |

## Chaves
- Primária: id_funcionario_unidade
- Únicas: -
- Estrangeiras: fk_fu_funcionario (id_funcionario → funcionario.id_funcionario); fk_funcionario_unidade_unidade (id_unidade → unidade.id_unidade)

## Índices
- idx_fu_funcionario (id_funcionario)
- idx_fu_unidade (id_unidade)

## Constraints
- CONSTRAINT fk_fu_funcionario FOREIGN KEY (id_funcionario) REFERENCES funcionario (id_funcionario)
- CONSTRAINT fk_funcionario_unidade_unidade FOREIGN KEY (id_unidade) REFERENCES unidade (id_unidade)

## Relacionamentos e Cardinalidade
- funcionario_unidade.id_funcionario → funcionario (id_funcionario): N:1 (várias unidades podem estar associadas ao mesmo funcionário)
- funcionario_unidade.id_unidade → unidade (id_unidade): N:1 (vários funcionários podem atuar na mesma unidade)

## Dependências
- Tabelas que dependem desta: -
- Esta tabela depende de: funcionario, unidade

## Fluxo de utilização dentro do sistema
1. Funcionário é vinculado a uma unidade com sua função específica
2. funcao_unidade define o cargo naquela unidade (plantonista, pediatra, etc)
3. data_inicio e data_fim controlam período de atuação
4. ativo indica se está trabalhando atualmente na unidade
5. Permite gestão de equipes por unidade/setor