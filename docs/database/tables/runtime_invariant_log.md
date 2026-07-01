# runtime_invariant_log

Objetivo: Registrar logs de invariantes do sistema runtime para verificação de integridade e consistência dos dados.

Descrição: Tabela que armazena logs de verificação de invariantes do sistema, permitindo auditoria de consistência dos dados e detecção de estados inválidos.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|--------|------|----------|---------|------------------|
| id_invariant | bigint | NOT NULL | - | Chave primária da tabela, identificador único do log de invariante |
| uuid_runtime | char(36) | NOT NULL | - | UUID do runtime que gerou o log |
| id_unidade | bigint unsigned | NOT NULL | - | Referência ao id da unidade onde o invariante foi verificado |
| tipo_invariante | varchar(80) | NOT NULL | - | Tipo de invariante verificado (ex: INTEGRIDADE_DADO, CONSISTENCIA_ESTADO) |
| payload_original | json | YES | NULL | Payload JSON original que foi verificado |
| hash_payload | char(64) | NOT NULL | - | Hash do payload para verificação de integridade |
| estado_valido | tinyint(1) | - | '1' | Flag indicando se o estado é válido (1) ou inválido (0) |
| criado_em | datetime(6) | - | CURRENT_TIMESTAMP(6) | Data e hora de criação do log |
| id_entidade | bigint unsigned | NOT NULL | - | Identificador da entidade/organização onde o log foi gerado |

## Chaves
- Primária: id_invariant
- Únicas: -
- Estrangeiras: fk_runtime_invariant_log_unidade (id_unidade → unidade.id_unidade) - vincula o log à unidade; fk_runtime_invariant_log_entidade (id_entidade → saas_entidade.id_entidade) - vincula o log à entidade |

## Índices
- PRIMARY KEY (id_invariant)
- KEY idx_invariant_uuid (uuid_runtime)
- KEY idx_invariant_estado (estado_valido)
- KEY fk_runtime_invariant_log_unidade (id_unidade)
- KEY fk_runtime_invariant_log_entidade (id_entidade)

## Constraints
- CONSTRAINT fk_runtime_invariant_log_entidade FOREIGN KEY (id_entidade) REFERENCES saas_entidade (id_entidade)
- CONSTRAINT fk_runtime_invariant_log_unidade FOREIGN KEY (id_unidade) REFERENCES unidade (id_unidade)

## Relacionamentos e Cardinalidade
- N:1 com unidade (uma unidade pode ter vários logs de invariantes)
- N:1 com saas_entidade (uma entidade pode ter vários logs)

## Dependências
- Tabelas que dependem desta: -
| Esta tabela depende de: unidade, saas_entidade

## Fluxo de utilização dentro do sistema
- Criado quando invariantes são verificados no runtime
- Permite detecção de estados inválidos no sistema
- Hash do payload permite verificação de integridade
- Usado para auditoria e debug de inconsistências