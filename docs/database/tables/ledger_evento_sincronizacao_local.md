# ledger_evento_sincronizacao_local

Objetivo: Registrar eventos de sincronização local com variantes de estado e campos comparativos ao ledger central.
Descrição: Tabela similar ao ledger_evento_sincronizacao mas com semântica de sincronização local, permitindo diferentes estratégias de sync no ambiente edge. Possui campos ligeiramente diferentes (ex: estado_sincronizacao default 'PENDENTE').

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
| `origem_contexto` | enum('LOCAL_EDGE','SYNC_CLOUD') | NOT NULL | - | Origem do evento: LOCAL_EDGE ou SYNC_CLOUD |
| `estado_sincronizacao` | enum('PENDENTE','ENVIADO','CONFIRMADO','REPROCESSAR','ERRO') | NULL | 'PENDENTE' | Estado atual da sincronização |
| `tentativas_sync` | int | NULL | '0' | Número de tentativas de sincronização já realizadas |
| `timestamp_evento` | datetime(6) | NOT NULL | - | Timestamp do evento nos origem (com precisão de microssegundos) |
| `timestamp_registro` | datetime(6) | NULL | CURRENT_TIMESTAMP(6) | Timestamp de registro no ledger |
| `versao_schema` | int | NOT NULL | - | Versão do schema para controle de evolução |
| `criado_em` | datetime(6) | NULL | CURRENT_TIMESTAMP(6) | Timestamp de criação do registro |
| `id_entidade` | bigint unsigned | NOT NULL | - | Referência à entidade proprietária |

## Chaves
- Primária: `id_evento` (char(36) - UUID)
- Únicas: -
- Estrangeiras: 
  - `fk_ledger_evento_sincronizacao_local_unidade` (`id_unidade`) → `unidade` (`id_unidade`) - Vincula evento à unidade

## Índices
- `idx_ledger_tenant` (KEY) - Índice em `id_tenant`
- `idx_ledger_unidade` (KEY) - Índice em `id_unidade`
- `idx_ledger_local` (KEY) - Índice em `id_local_operacional`
- `idx_ledger_estado_sync` (KEY) - Índice em `estado_sincronizacao`
- `idx_ledger_timestamp_evt` (KEY) - Índice em `timestamp_evento`
- `idx_ledger_tipo_evento` (KEY) - Índice em `tipo_evento`

## Constraints
- `fk_ledger_evento_sincronizacao_local_unidade` FOREIGN KEY - Relaciona `id_unidade` com `unidade`.`id_unidade`

## Relacionamentos e Cardinalidade
- N:1 com `unidade` - Muitos eventos pertencem a uma unidade
- N:1 com `tenant` - Muitos eventos pertencem a um tenant
- N:1 com `sistema` - Muitos eventos pertencem a um sistema
- N:1 com `local_operacional` - Muitos eventos podem estar associados a um local

## Dependências
- Esta tabela é referenciada por: (não possui FK apontando para ela)
- Esta tabela depende de: `unidade`, `tenant`, `sistema`, `local_operacional`, `saas_entidade`

## Fluxo de utilização dentro do sistema
1. Usada em ambientes edge para armazenar eventos antes da sincronização
2. Diferente do ledger_evento_sincronizacao central, possui defaults ligeiramente diferentes
3. Permite sincronização diferida de eventos entre edge e cloud
4. Usada quando a conectividade é intermitente ou indisponível
5. O sincronizador transfere eventos para o ledger central
6. Permite reconciliação de eventos entre múltiplos ambientes edge