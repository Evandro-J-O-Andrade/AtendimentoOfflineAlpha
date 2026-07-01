# atendimento_vinculo

Objetivo: Estabelecer o vínculo entre um atendimento e uma FFA (Ficha de Atendimento).
Descrição: Tabela de relacionamento que associa atendimentos a fichas de atendimento (FFA), garantindo a integridade da relação 1:1 entre atendimento e ficha.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|--------|------|----------|---------|------------------|
| id | bigint | NOT NULL | - | Identificador único do vínculo, chave primária auto incrementada. |
| id_ffa | bigint | NOT NULL | - | Referência à FFA (Ficha de Atendimento) vinculada ao atendimento. |
| id_atendimento | bigint unsigned | NOT NULL | - | Referência ao atendimento que está vinculado à FFA. |
| ativo | tinyint | Nullable | '1' | Indicador de se o vínculo está ativo (1) ou desativado (0). |
| criado_em | datetime(6) | NOT NULL | - | Timestamp de criação do vínculo com precisão de microsegundos. |
| id_entidade | bigint unsigned | NOT NULL | - | Referência à entidade (organização) à qual o registro pertence. |

## Chaves
- Primária: id
- Únicas: uk_ffa (id_ffa)
- Estrangeiras:
  - fk_atendimento_vinculo_atendimento: id_atendimento → atendimento (id_atendimento) - Relacionamento 1:1 com atendimento, deleta em cascata
  - fk_atendimento_vinculo_entidade: id_entidade → saas_entidade (id_entidade)

## Índices
- PRIMARY KEY (id)
- UNIQUE KEY uk_ffa (id_ffa)
- KEY fk_atendimento_vinculo_atendimento (id_atendimento)
- KEY idx_avinc_ent (id_entidade)

## Constraints
- PRIMARY KEY: id
- UNIQUE: uk_ffa (id_ffa)
- FOREIGN KEY: fk_atendimento_vinculo_atendimento (id_atendimento) REFERENCES atendimento (id_atendimento) ON DELETE CASCADE ON UPDATE CASCADE
- FOREIGN KEY: fk_atendimento_vinculo_entidade (id_entidade) REFERENCES saas_entidade (id_entidade)

## Relacionamentos e Cardinalidade
- 1:1 com atendimento (id_atendimento)
- 1:1 com FFA (id_ffa) - cada FFA pode ter apenas um vínculo ativo
- N:1 com saas_entidade (id_entidade)

## Dependências
- Tabelas que dependem desta: nenhuma
- Dependência desta tabela: atendimento, saas_entidade

## Fluxo de utilização dentro do sistema
- Criada quando um atendimento é associado a uma FFA
- Garante integridade do vínculo entre atendimento e ficha
- Utilizada para rastrear qual FFA está associada a cada atendimento
- O constraint único em id_ffa impede que uma FFA seja vinculada a múltiplos atendimentos