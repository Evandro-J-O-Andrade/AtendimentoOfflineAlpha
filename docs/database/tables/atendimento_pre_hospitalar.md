# atendimento_pre_hospitalar

Objetivo: Registrar atendimentos pré-hospitalares como SAMU, UBS, remoção e farmácia, controlando tipo, descrição e período da intervenção.

Descrição: Esta tabela armazena informações sobre atendimentos realizados antes do hospital (SAMU, UBS, remoção, farmácia), permitindo o registro da descrição da intervenção, início e fim, com vinculação ao atendimento principal.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|---------|------|----------|---------|------------------|
| id_pre_hospitalar | bigint unsigned | NOT NULL | AUTO_INCREMENT | Identificador único do atendimento pré-hospitalar |
| id_atendimento | bigint unsigned | NOT NULL | - | Chave estrangeira que referencia o atendimento ao qual o atendimento pré-hospitalar pertence |
| tipo_intervencao | enum('SAMU','UBS','REMOCAO','FARMACIA') | NOT NULL | - | Tipo de intervenção pré-hospitalar: SAMU, UBS, remoção ou farmácia |
| descricao | text | YES | NULL | Descrição completa da intervenção realizada |
| inicio_em | datetime(6) | YES | NULL | Timestamp do início da intervenção pré-hospitalar |
| fim_em | datetime(6) | YES | NULL | Timestamp do fim da intervenção pré-hospitalar |
| criado_em | datetime(6) | NOT NULL | CURRENT_TIMESTAMP(6) | Timestamp automático da data/hora de criação do registro |
| id_entidade | bigint unsigned | NOT NULL | - | Identificador da entidade (organização/unidade) à qual o registro pertence |

## Chaves
- Primária: id_pre_hospitalar
- Únicas: Nenhuma
- Estrangeiras: fk_atendimento_pre_hospitalar_atendimento - id_atendimento → atendimento(id_atendimento) - Vincula o atendimento pré-hospitalar ao atendimento; fk_atendimento_pre_hospitalar_entidade - id_entidade → saas_entidade(id_entidade) - Vincula o atendimento à entidade; fk_pre_hosp_atendimento - id_atendimento → atendimento(id_atendimento) - Vincula novamente ao atendimento (constraint duplicada) |

## Índices
- idx_pre_hosp_atendimento (KEY) - Índice para busca por atendimento
- idx_aph_ent (KEY) - Índice para busca por entidade

## Constraints
- fk_atendimento_pre_hospitalar_atendimento - FOREIGN KEY - Restringe id_atendimento à tabela atendimento(id_atendimento) com CASCADE
- fk_atendimento_pre_hospitalar_entidade - FOREIGN KEY - Restringe id_entidade à tabela saas_entidade(id_entidade)
- fk_pre_hosp_atendimento - FOREIGN KEY - Restringe id_atendimento à tabela atendimento(id_atendimento)

## Relacionamentos e Cardinalidade
- N:1 com atendimento - Cada atendimento pré-hospitalar está associado a um atendimento (várias constraints)
- N:1 com saas_entidade - Cada atendimento pré-hospitalar pertence a uma entidade SaaS

## Dependências
- Tabelas que dependem desta: Nenhuma (não há FK apontando para atendimento_pre_hospitalar)
- Tabelas das quais esta depende: atendimento, saas_entidade

## Fluxo de utilização dentro do sistema
- Registro de atendimentos pré-hospitalares antes do atendimento principal
- Tipos de intervenção: SAMU (atendimento móvel), UBS (unidade básica), remoção, farmácia
- Descrição livre para detalhar a intervenção realizada
- Período de início e fim para controle de tempo da intervenção
- Múltiplas constraints FK para atendimento (arquitetura redundante para integridade)
- Cascade delete remove atendimentos pré-hospitalares quando atendimento é excluído