# atendimento_identidade_fluxo

Objetivo: Registrar a identidade do fluxo assistencial para rastreamento em sistemas offline e ambientes federados, vinculando UUIDs a FFAs e pessoas assistidas.

Descrição: Esta tabela mantém a identidade do fluxo assistencial para suporte a operações offline e federadas, registrando UUIDs de evento e pessoa, tipo de entidade, origem do cadastro e metadados para reconciliação de dados.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|---------|------|----------|---------|------------------|
| id_fluxo | bigint | NOT NULL | AUTO_INCREMENT | Identificador único do registro de identidade de fluxo |
| uuid_evento | char(36) | NOT NULL | - | UUID único do evento para identificação global |
| uuid_pessoa_assistida | char(36) | NOT NULL | - | UUID da pessoa assistida (paciente, funcionário, visitante) |
| tipo_entidade | enum('PACIENTE','FUNCIONARIO','VISITANTE','OUTRO') | NOT NULL | - | Tipo de entidade identificada: paciente, funcionário, visitante ou outro |
| origem_cadastro | enum('CENTRAL','EDGE_RUNTIME','PROVISORIO_OFFLINE') | NOT NULL | - | Origem do cadastro: central, edge runtime ou provisório offline |
| metadata_fluxo | json | NOT NULL | - | Metadados em JSON com informações complementares do fluxo |
| criado_em | datetime(6) | YES | CURRENT_TIMESTAMP(6) | Timestamp automático da data/hora de criação do registro |
| id_atendimento | bigint unsigned | NOT NULL | - | Chave estrangeira que referencia o atendimento ao qual a identidade pertence |
| id_entidade | bigint unsigned | NOT NULL | - | Identificador da entidade (organização/unidade) à qual o registro pertence |

## Chaves
- Primária: id_fluxo
- Únicas: uk_fluxo_evento (uuid_evento) - Garante que cada UUID de evento seja único
- Estrangeiras: fk_atendimento_identidade_fluxo_atendimento - id_atendimento → atendimento(id_atendimento) - Vincula a identidade ao atendimento; fk_atendimento_identidade_fluxo_entidade - id_entidade → saas_entidade(id_entidade) - Vincula a identidade à entidade |

## Índices
- uk_fluxo_evento (KEY) - Índice único para garantir unicidade do UUID de evento
- idx_fluxo_pessoa (KEY) - Índice para busca por pessoa assistida
- fk_atendimento_identidade_fluxo_atendimento (KEY) - Índice para busca por atendimento
- idx_aidflux_ent (KEY) - Índice para busca por entidade

## Constraints
- uk_fluxo_evento - UNIQUE - Garante unicidade do uuid_evento
- fk_atendimento_identidade_fluxo_atendimento - FOREIGN KEY - Restringe id_atendimento à tabela atendimento(id_atendimento) com CASCADE
- fk_atendimento_identidade_fluxo_entidade - FOREIGN KEY - Restringe id_entidade à tabela saas_entidade(id_entidade)

## Relacionamentos e Cardinalidade
- N:1 com atendimento - Cada identidade de fluxo está associada a um atendimento (com CASCADE)
- N:1 com saas_entidade - Cada identidade pertence a uma entidade SaaS

## Dependências
- Tabelas que dependem desta: Nenhuma (não há FK apontando para atendimento_identidade_fluxo)
- Tabelas das quais esta depende: atendimento, saas_entidade

## Fluxo de utilização dentro do sistema
- Identificação única de pessoas assistidas via UUID
- Suporte a operação offline com origem CENTRAL, EDGE_RUNTIME ou PROVISORIO_OFFLINE
- UUIDs para reconciliação de dados entre sistemas distribuídos
- Metadados JSON para armazenamento flexível de informações complementares
- Unicidade garantida por UK para uuid_evento
- Cascade delete remove identidades quando atendimento é excluído