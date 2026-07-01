# guardiao_runtime_final

Objetivo: Controlar o resultado final das verificações de guardião.

Descrição: Tabela que armazena os resultados finais das verificações de segurança do guardião, mantendo estado de permissão ou bloqueio com motivo. Utiliza UUID para identificação única de cada verificação.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|---------|------|----------|---------|------------------|
| id_guardiao | bigint | NOT NULL | - | Identificador único do registro, chave primária auto incrementada |
| uuid_runtime | char(36) | NOT NULL | - | UUID único que identifica a verificação runtime |
| id_unidade | bigint unsigned | NOT NULL | - | Referência à unidade onde a verificação ocorreu |
| hash_contexto | char(64) | NOT NULL | - | Hash que representa o contexto da verificação |
| estado_permitido | tinyint(1) | DEFAULT | '1' | Indicador se a verificação foi permitida (1=sim, 0=não) |
| motivo_bloqueio | varchar(255) | DEFAULT NULL | - | Motivo do bloqueio caso estado_permitido=0 |
| criado_em | datetime(6) | DEFAULT | CURRENT_TIMESTAMP(6) | Data e hora de criação do registro |
| atualizado_em | datetime(6) | DEFAULT NULL ON UPDATE | CURRENT_TIMESTAMP(6) | Data e hora da última atualização |
| id_entidade | bigint unsigned | NOT NULL | - | Referência à entidade (organização) associada |

## Chaves
- Primária: id_guardiao
- Únicas: -
- Estrangeiras: fk_guardiao_runtime_final_unidade (id_unidade → unidade.id_unidade); fk_guardiao_runtime_final_entidade (id_entidade → saas_entidade.id_entidade)

## Índices
- idx_guardiao_uuid (uuid_runtime)
- idx_guardiao_estado (estado_permitido)
- fk_guardiao_runtime_final_unidade (id_unidade)
- fk_guardiao_runtime_final_entidade (id_entidade)

## Constraints
- CONSTRAINT fk_guardiao_runtime_final_entidade FOREIGN KEY (id_entidade) REFERENCES saas_entidade (id_entidade)
- CONSTRAINT fk_guardiao_runtime_final_unidade FOREIGN KEY (id_unidade) REFERENCES unidade (id_unidade)

## Relacionamentos e Cardinalidade
- guardiao_runtime_final.id_unidade → unidade (id_unidade): N:1
- guardiao_runtime_final.id_entidade → saas_entidade (id_entidade): N:1

## Dependências
- Tabelas que dependem desta: -
- Esta tabela depende de: unidade, saas_entidade

## Fluxo de utilização dentro do sistema
1. Sistema guardião realiza verificação de acesso
2. Registro é criado com UUID único para rastreamento
3. hash_contexto identifica unicamente o contexto verificado
4. estado_permitido indica se o acesso foi autorizado
5. motivo_bloqueio explica o motivo da negação
6. Permite auditoria e rastreamento de decisões de segurança