# assistencial_snapshot_runtime

Objetivo: Armazenar snapshots de estado de runtime para FFAs, permitindo recuperação e consistência de dados em sistemas distribuídos.

Descrição: Esta tabela mantém snapshots do estado do runtime para FFAs (Fichas de Atendimento), contendo o estado atual, hash do estado e vinculando ao atendimento e entidade correspondente, com unicidade garantida por FFA.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|---------|------|----------|---------|------------------|
| id_snapshot | bigint | NOT NULL | AUTO_INCREMENT | Identificador único do snapshot de runtime |
| id_ffa | bigint | NOT NULL | - | Identificador da FFA (Ficha de Atendimento) ao qual o snapshot pertence |
| estado_runtime | varchar(60) | YES | NULL | Estado atual do runtime da FFA (ex: INICIADO, EM_CURSO, FINALIZADO) |
| hash_estado | char(64) | YES | NULL | Hash criptográfico do estado para verificação de integridade |
| criado_em | datetime(6) | YES | CURRENT_TIMESTAMP(6) | Timestamp automático da data/hora de criação do snapshot |
| id_atendimento | bigint unsigned | NOT NULL | - | Chave estrangeira que referencia o atendimento ao qual o snapshot pertence |
| id_entidade | bigint unsigned | NOT NULL | - | Identificador da entidade (organização/unidade) à qual o snapshot pertence |

## Chaves
- Primária: id_snapshot
- Únicas: uk_snapshot_ffa (id_ffa) - Garante um único snapshot por FFA
- Estrangeiras: fk_assistencial_snapshot_runtime_atendimento - id_atendimento → atendimento(id_atendimento) ON DELETE CASCADE - Vincula o snapshot ao atendimento; fk_assistencial_snapshot_runtime_entidade - id_entidade → saas_entidade(id_entidade) - Vincula o snapshot à entidade

## Índices
- uk_snapshot_ffa (KEY) - Índice único para garantir unicidade por FFA
- fk_assistencial_snapshot_runtime_atendimento (KEY) - Índice para busca por atendimento
- idx_asr_ent (KEY) - Índice para busca por entidade

## Constraints
- uk_snapshot_ffa - UNIQUE - Garante unicidade do id_ffa no snapshot
- fk_assistencial_snapshot_runtime_atendimento - FOREIGN KEY - Restringe id_atendimento à tabela atendimento(id_atendimento) com CASCADE DELETE
- fk_assistencial_snapshot_runtime_entidade - FOREIGN KEY - Restringe id_entidade à tabela saas_entidade(id_entidade)

## Relacionamentos e Cardinalidade
- N:1 com atendimento - Cada snapshot está associado a um atendimento (com CASCADE)
- N:1 com saas_entidade - Cada snapshot pertence a uma entidade SaaS

## Dependências
- Tabelas que dependem desta: Nenhuma (não há FK apontando para assistencial_snapshot_runtime)
- Tabelas das quais esta depende: atendimento, saas_entidade

## Fluxo de utilização dentro do sistema
- Snapshot do estado do runtime para cada FFA
- Estado textual e hash para verificação de integridade
- Unicidade garantida por UK para evitar múltiplos snapshots de mesma FFA
- Cascade delete remove snapshot quando atendimento é excluído
- Índice para busca eficiente por atendimento e entidade