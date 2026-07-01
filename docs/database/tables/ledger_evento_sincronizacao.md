# ledger_evento_sincronizacao

Objetivo: Registrar eventos que precisam ser sincronizados entre o ambiente local (edge) e a nuvem (cloud).
Descrição: Tabela central do ledger de sincronização que armazena eventos pendentes de replicação entre ambientes distribuídos. Controla o estado de sincronização (PENDENTE, ENVIADO, CONFIRMADO, REPROCESSAR, ERRO) e número de tentativas de envio.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|--------|------|----------|---------|------------------|
| `id_evento` | char(36) | NOT NULL | - | UUID único do evento (chave primária) |
| `id_tenant` | bigint | NOT NULL | - | Identificador do tenant (organização cliente) |
| `id_sistema` | bigint | NOT NULL | - | Identificador do sistema que gerou o evento |
| `id_unidade` | bigint unsigned | NOT NULL | - | Referência à unidade de saúde onde o evento ocorreu |
| `id_local_operacional` | bigint | NULL | NULL | Referência ao local operacional específico |
| `tipo_evento` | varchar(50) | NOT NULL | - | Tipo do evento (ex: ATENDIMENTO_CRIADO, PRESCRICAO_ATUALIZADA) |
| `subtipo_evento` | varchar(50) | NULL | NULL | Subtipo do evento para classificação mais detalhada |
| `payload_json` | json | NOT NULL | - | Payload JSON contendo os dados do evento |
| `hash_integridade` | char(64) | NOT NULL | - | Hash SHA256 para verificação de integridade dos dados |
| `origem_contexto` | enum('LOCAL_EDGE','SYNC_CLOUD') | NOT NULL | - | Origem do evento: LOCAL_EDGE (gerado localmente) ou SYNC_CLOUD (recebido da nuvem) |
| `estado_sincronizacao` | enum('PENDENTE','ENVIADO','CONFIRMADO','REPROCESSAR','ERRO') | NOT NULL | 'PENDENTE' | Estado atual da sincronização |
| `tentativas_sync` | int | NOT NULL | '0' | Número de tentativas de sincronização já realizadas |
| `timestamp_evento` | datetime(6) | NOT NULL | - | Timestamp do evento nos origem (com precisão de microssegundos) |
| `timestamp_registro` | datetime(6) | NOT NULL | CURRENT_TIMESTAMP(6) | Timestamp de registro do evento no ledger |
| `versao_schema` | int | NOT NULL | - | Versão do schema para controle de evolução de dados |
| `criado_em` | datetime(6) | NOT NULL | CURRENT_TIMESTAMP(6) | Timestamp de criação do registro |
| `id_entidade` | bigint unsigned | NOT NULL | - | Referência à entidade proprietária |

## Chaves
- Primária: `id_evento` (char(36) - UUID)
- Únicas: -
- Estrangeiras: 
  - `fk_ledger_evento_sincronizacao_unidade` (`id_unidade`) → `unidade` (`id_unidade`) - Vincula evento à unidade

## Índices
- `idx_ledger_tenant` (KEY) - Índice em `id_tenant`
- `idx_ledger_sistema` (KEY) - Índice em `id_sistema`
- `idx_ledger_unidade` (KEY) - Índice em `id_unidade`
- `idx_ledger_estado` (KEY) - Índice em `estado_sincronizacao`
- `idx_ledger_timestamp` (KEY) - Índice em `timestamp_evento`
- `idx_ledger_hash` (KEY) - Índice em `hash_integridade`

## Constraints
- `fk_ledger_evento_sincronizacao_unidade` FOREIGN KEY - Relaciona `id_unidade` com `unidade`.`id_unidade`

## Relacionamentos e Cardinalidade
- N:1 com `unidade` - Muitos eventos de sincronização pertencem a uma unidade
- N:1 com `tenant` - Muitos eventos pertencem a um tenant
- N:1 com `sistema` - Muitos eventos pertencem a um sistema
- N:1 com `local_operacional` - Muitos eventos podem estar associados a um local

## Dependências
- Esta tabela é referenciada por: (não possui FK apontando para ela)
- Esta tabela depende de: `unidade`, `tenant`, `sistema`, `local_operacional`, `saas_entidade`

## Fluxo de utilização dentro do sistema
1. Eventos são gerados em ambientes edge (offline) com estado PENDENTE
2. O sincronizador envia eventos com estado ENVIADO
3. Ao receber confirmação, atualiza para CONFIRMADO
4. Eventos com falha são marcados como ERRO para retry
5. Estado REPROCESSAR é usado para eventos que precisam ser reprocessados
6. O hash_integridade verifica integridade dos dados após sincronização
7. versao_schema permite evolução de formato de dados
8. Usado para garantir consistência entre ambientes distribuídos