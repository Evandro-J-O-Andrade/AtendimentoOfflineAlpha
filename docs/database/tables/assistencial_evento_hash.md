# assistencial_evento_hash

Objetivo: Armazenar hashes de eventos assistenciais para detecção de duplicação e reconciliação de eventos em sistemas distribuídos.

Descrição: Esta tabela mantém um repositório de fingerprints de eventos assistenciais para garantir a unicidade e detectar duplicações em ambientes federados, vinculando cada hash ao FFA, evento e entidade correspondente.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|---------|------|----------|---------|------------------|
| id_hash | bigint | NOT NULL | AUTO_INCREMENT | Identificador único do hash de evento |
| hash_fingerprint | char(64) | NOT NULL | - | Hash único (64 caracteres) do evento para detecção de duplicação e reconciliação |
| id_ffa | bigint | NOT NULL | - | Identificador da FFA (Ficha de Atendimento) ao qual o evento pertence |
| evento | varchar(60) | NOT NULL | - | Nome ou código do tipo de evento assistencial |
| criado_em | datetime(6) | YES | CURRENT_TIMESTAMP(6) | Timestamp automático da data/hora de criação do registro |
| id_entidade | bigint unsigned | NOT NULL | - | Identificador da entidade (organização/unidade) à qual o hash pertence |

## Chaves
- Primária: id_hash
- Únicas: uk_assistencial_hash_fingerprint (hash_fingerprint) - Garante que cada fingerprint de evento seja único no sistema
- Estrangeiras: Nenhuma

## Índices
- uk_assistencial_hash_fingerprint (KEY) - Índice único para verificação de unicidade de hash
- idx_assistencial_hash_lookup (KEY) - Índice composto por id_ffa e evento para busca de eventos por FFA

## Constraints
- uk_assistencial_hash_fingerprint - UNIQUE - Garante que cada fingerprint de evento seja único

## Relacionamentos e Cardinalidade
- Esta tabela não possui relacionamentos com outras tabelas via foreign key

## Dependências
- Tabelas que dependem desta: Nenhuma (não há FK apontando para assistencial_evento_hash)
- Tabelas das quais esta depende: Nenhuma

## Fluxo de utilização dentro do sistema
- Geração de hash único para cada evento assistencial
- Prevenção de duplicação de eventos em sistemas distribuídos
- Reconciliação entre nós do ambiente federado via fingerprint
- Busca eficiente de eventos por FFA e tipo via índice composto
- Timestamp para controle de quando o hash foi registrado
- Identificação do tipo de evento para classificação