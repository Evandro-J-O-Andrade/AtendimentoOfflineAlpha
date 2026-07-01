# assistencial_checkpoint_global

Objetivo: Registrar checkpoints globais de estado para FFAs, garantindo a consistência e validação do quorum clínico no sistema.

Descrição: Esta tabela mantém o controle de checkpoints globais para verificar a consistência do estado dos FFAs (Fichas de Atendimento) em sistemas distribuídos, com verificação de quorum clínico válido e snapshot do estado atual.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|---------|------|----------|---------|------------------|
| id_checkpoint | bigint | NOT NULL | AUTO_INCREMENT | Identificador único do checkpoint global |
| id_ffa | bigint | NOT NULL | - | Identificador da FFA (Ficha de Atendimento) ao qual o checkpoint está vinculado |
| estado_snapshot | varchar(60) | NOT NULL | - | Estado do snapshot da FFA no momento do checkpoint |
| quorum_valido | tinyint(1) | YES | '0' | Flag que indica se o quorum clínico foi validado (1) ou não (0) |
| criado_em | datetime(6) | YES | CURRENT_TIMESTAMP(6) | Timestamp automático da data/hora de criação do checkpoint |
| id_atendimento | bigint unsigned | NOT NULL | - | Chave estrangeira que referencia o atendimento associado ao checkpoint |
| id_entidade | bigint unsigned | NOT NULL | - | Identificador da entidade (organização/unidade) à qual o checkpoint pertence |

## Chaves
- Primária: id_checkpoint
- Únicas: uk_checkpoint_ffa (id_ffa) - Garante um único checkpoint por FFA
- Estrangeiras: fk_assistencial_checkpoint_global_atendimento - id_atendimento → atendimento(id_atendimento) ON DELETE CASCADE - Vincula o checkpoint ao atendimento; fk_assistencial_checkpoint_global_entidade - id_entidade → saas_entidade(id_entidade) - Vincula o checkpoint à entidade

## Índices
- fk_assistencial_checkpoint_global_atendimento (KEY) - Índice para busca por atendimento
- idx_acg_ent (KEY) - Índice para busca por entidade

## Constraints
- uk_checkpoint_ffa - UNIQUE - Garante unicidade do id_ffa no checkpoint
- fk_assistencial_checkpoint_global_atendimento - FOREIGN KEY - Restringe id_atendimento à tabela atendimento(id_atendimento) com CASCADE DELETE
- fk_assistencial_checkpoint_global_entidade - FOREIGN KEY - Restringe id_entidade à tabela saas_entidade(id_entidade)

## Relacionamentos e Cardinalidade
- 1:1 com atendimento - Cada checkpoint está associado a um atendimento único (com CASCADE)
- N:1 com saas_entidade - Cada checkpoint pertence a uma entidade SaaS

## Dependências
- Tabelas que dependem desta: assistencial_evento_hash, assistencial_snapshot_runtime (ambas via id_ffa indiretamente), Nenhuma outra tabela possui FK direta para esta
- Tabelas das quais esta depende: atendimento, saas_entidade

## Fluxo de utilização dentro do sistema
- Validação de quorum clínico para FFAs em ambiente federado
- Snapshot do estado para consistência entre nós
- Única ocorrência por FFA para controle de checkpoint
- Valor booleano para quorum_valido indicando validade da verificação
- Cascade delete remove checkpoint quando atendimento é excluído