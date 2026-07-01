# atendimento_transicao_ledger

Objetivo: Registrar todas as transições de estado do atendimento em um ledger imutável para auditoria e rastreabilidade.
Descrição: Tabela de ledger que registra cada mudança de estado do atendimento (estado_origem → estado_destino), mantendo histórico completo com hash de fingerprint para integridade e controle de consistência.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|--------|------|----------|---------|------------------|
| id | bigint | NOT NULL | - | Identificador único do registro de transição, chave primária auto incrementada. |
| uuid_transacao | char(64) | NOT NULL | - | UUID único da transação de mudança de estado. |
| estado_origem | varchar(60) | Nullable | - | Estado anterior do atendimento antes da transição. |
| estado_destino | varchar(60) | Nullable | - | Estado novo do atendimento após a transição. |
| fingerprint_hash | char(64) | Nullable | - | Hash de fingerprint para validação de integridade dos dados. |
| criado_em | datetime(6) | Nullable | CURRENT_TIMESTAMP(6) | Timestamp de criação do registro com precisão de microsegundos. |
| id_atendimento | bigint unsigned | NOT NULL | - | Referência ao atendimento que sofreu a transição. |
| id_entidade | bigint unsigned | NOT NULL | - | Referência à entidade (organização) à qual o registro pertence. |

## Chaves
- Primária: id
- Únicas: uk_transacao_uuid (uuid_transacao)
- Estrangeiras:
  - fk_atendimento_transicao_ledger_atendimento: id_atendimento → atendimento (id_atendimento) - Relacionamento N:1 com atendimento, deleta em cascata
  - fk_atendimento_transicao_ledger_entidade: id_entidade → saas_entidade (id_entidade)

## Índices
- PRIMARY KEY (id)
- UNIQUE KEY uk_transacao_uuid (uuid_transacao)
- KEY idx_transicao_hash (fingerprint_hash)
- KEY fk_atendimento_transicao_ledger_atendimento (id_atendimento)
- KEY idx_atrans_ent (id_entidade)

## Constraints
- PRIMARY KEY: id
- UNIQUE: uk_transacao_uuid (uuid_transacao)
- FOREIGN KEY: fk_atendimento_transicao_ledger_atendimento (id_atendimento) REFERENCES atendimento (id_atendimento) ON DELETE CASCADE ON UPDATE CASCADE
- FOREIGN KEY: fk_atendimento_transicao_ledger_entidade (id_entidade) REFERENCES saas_entidade (id_entidade)

## Relacionamentos e Cardinalidade
- N:1 com atendimento (id_atendimento) - muitos registros de transição por atendimento
- N:1 com saas_entidade (id_entidade)

## Dependências
- Tabelas que dependem desta: nenhuma
- Dependência desta tabela: atendimento, saas_entidade

## Fluxo de utilização dentro do sistema
- Registrada automaticamente a cada mudança de estado do atendimento
- Utilizada para auditoria e rastreio de mudanças de estado
- Fingerprint hash permite validação de integridade
- Usada em processos de conciliação e verificação de consistência de dados