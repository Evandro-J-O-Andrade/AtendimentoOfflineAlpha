# assistencial_runtime_federado

Objetivo: Armazenar snapshots do estado federado de atendimentos, permitindo sincronização e consistência de dados em ambientes distribuídos.

Descrição: Esta tabela mantém snapshots do runtime federado para atendimentos, contendo hash de runtime, payload JSON com dados completos, status de sincronização e vinculando ao atendimento e entidade correspondente.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|---------|------|----------|---------|------------------|
| id_snapshot | bigint | NOT NULL | AUTO_INCREMENT | Identificador único do snapshot do runtime federado |
| id_sistema | bigint | NOT NULL | - | Identificador do sistema ao qual o snapshot pertence |
| hash_runtime | char(64) | YES | NULL | Hash do estado do runtime para verificação de integridade e mudanças |
| payload_json | json | YES | NULL | Payload JSON completo com o estado do runtime federado |
| sincronizado | tinyint(1) | YES | '0' | Flag que indica se o snapshot foi sincronizado (1) ou não (0) |
| criado_em | datetime(6) | YES | CURRENT_TIMESTAMP(6) | Timestamp automático da data/hora de criação do snapshot |
| id_atendimento | bigint unsigned | NOT NULL | - | Chave estrangeira que referencia o atendimento ao qual o snapshot pertence |
| id_entidade | bigint unsigned | NOT NULL | - | Identificador da entidade (organização/unidade) à qual o snapshot pertence |

## Chaves
- Primária: id_snapshot
- Únicas: Nenhuma
- Estrangeiras: fk_assistencial_runtime_federado_atendimento - id_atendimento → atendimento(id_atendimento) ON DELETE CASCADE - Vincula o snapshot ao atendimento; fk_assistencial_runtime_federado_entidade - id_entidade → saas_entidade(id_entidade) - Vincula o snapshot à entidade

## Índices
- idx_runtime_federado (KEY) - Índice composto por id_sistema e sincronizado
- fk_assistencial_runtime_federado_atendimento (KEY) - Índice para busca por atendimento
- idx_arf_ent (KEY) - Índice para busca por entidade

## Constraints
- fk_assistencial_runtime_federado_atendimento - FOREIGN KEY - Restringe id_atendimento à tabela atendimento(id_atendimento) com CASCADE DELETE
- fk_assistencial_runtime_federado_entidade - FOREIGN KEY - Restringe id_entidade à tabela saas_entidade(id_entidade)

## Relacionamentos e Cardinalidade
- N:1 com atendimento - Cada snapshot está associado a um atendimento (com CASCADE)
- N:1 com saas_entidade - Cada snapshot pertence a uma entidade SaaS

## Dependências
- Tabelas que dependem desta: assistencial_runtime_panel, assistencial_simulacao_futura, assistencial_snapshot_runtime (ambas via id_atendimento ou id_atendimento indiretamente)
- Tabelas das quais esta depende: atendimento, saas_entidade

## Fluxo de utilização dentro do sistema
- Snapshot do estado federado para sincronização entre nós
- Hash para detecção de mudanças no runtime
- Payload JSON completo para replicação de dados
- Controle de status de sincronização para processos de sync
- Cascade delete remove snapshots quando atendimento é excluído
- Índices para busca eficiente por sistema e status de sincronização