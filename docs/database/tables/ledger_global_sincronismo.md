# ledger_global_sincronismo

Objetivo: Ledger global de sincronização com ULID para ordenação temporal e controle de processamento distribuído.
Descrição: Tabela que usa ULID (Universally Unique Lexicographically Sortable Identifier) como chave primária, permitindo ordenação natural de eventos por tempo. Controla eventos globais de sincronização entre todos os ambientes, com estados de processamento mais detalhados incluindo CONFLITO.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|--------|------|----------|---------|------------------|
| `ulid_evento` | binary(16) | NOT NULL | - | ULID único (16 bytes) - chave primária e ordenável por tempo |
| `id_tenant` | bigint | NOT NULL | - | Identificador do tenant (organização cliente) |
| `id_sistema` | bigint | NOT NULL | - | Identificador do sistema que gerou o evento |
| `id_unidade` | bigint unsigned | NOT NULL | - | Referência à unidade de saúde onde o evento ocorreu |
| `id_local_operacional` | bigint | NULL | NULL | Referência ao local operacional específico |
| `origem_runtime` | varchar(40) | NOT NULL | - | Nome/ID do runtime de origem do evento |
| `contexto_origem` | varchar(50) | NULL | NULL | Contexto de origem do evento (ex: PACIENTE, ATENDIMENTO) |
| `tipo_evento` | varchar(60) | NOT NULL | - | Tipo do evento (ex: NOTIFICACAO_CRIADA, STATUS_ALTERADO) |
| `subtipo_evento` | varchar(60) | NULL | NULL | Subtipo do evento |
| `payload_json` | json | NOT NULL | - | Payload JSON contendo os dados do evento |
| `hash_integridade` | char(64) | NOT NULL | - | Hash SHA256 para verificação de integridade |
| `data_evento_local` | datetime(6) | NOT NULL | - | Data/hora do evento no ambiente de origem |
| `data_evento_central` | datetime(6) | NULL | NULL | Data/hora do evento após processamento central |
| `versao_schema` | int | NOT NULL | - | Versão do schema para evolução de dados |
| `estado_processamento` | enum('PENDENTE','PROCESSANDO','PROCESSADO','REPROCESSAR','ERRO','CONFLITO') | NULL | 'PENDENTE' | Estado de processamento com suporte a CONFLITO |
| `tentativas_sync` | int | NULL | '0' | Número de tentativas de sincronização |
| `criado_por` | bigint | NULL | NULL | Usuário que criou o evento original |
| `id_sessao_usuario` | bigint | NULL | NULL | Sessão do usuário que criou o evento |
| `criado_em` | datetime(6) | NULL | CURRENT_TIMESTAMP(6) | Timestamp de criação do registro |
| `id_entidade` | bigint unsigned | NOT NULL | - | Referência à entidade proprietária |

## Chaves
- Primária: `ulid_evento` (binary(16) - ULID)
- Únicas: -
- Estrangeiras: 
  - `fk_ledger_global_sincronismo_unidade` (`id_unidade`) → `unidade` (`id_unidade`) - Vincula evento à unidade

## Índices
- `idx_ledger_tenant` (KEY) - Índice em `id_tenant`
- `idx_ledger_unidade` (KEY) - Índice em `id_unidade`
- `idx_ledger_local` (KEY) - Índice em `id_local_operacional`
- `idx_ledger_estado` (KEY) - Índice em `estado_processamento`
- `idx_ledger_tipo_evt` (KEY) - Índice em `tipo_evento`
- `idx_ledger_runtime` (KEY) - Índice em `origem_runtime`
- `idx_ledger_schema` (KEY) - Índice em `versao_schema`
- `idx_ledger_timestamp` (KEY) - Índice em `data_evento_local`

## Constraints
- `fk_ledger_global_sincronismo_unidade` FOREIGN KEY - Relaciona `id_unidade` com `unidade`.`id_unidade`

## Relacionamentos e Cardinalidade
- N:1 com `unidade` - Muitos eventos globais pertencem a uma unidade
- N:1 com `tenant` - Muitos eventos pertencem a um tenant
- N:1 com `sistema` - Muitos eventos pertencem a um sistema
- N:1 com `usuario` - Muitos eventos podem ter sido criados pelo mesmo usuário
- N:1 com `sessao_usuario` - Muitos eventos podem estar associados a uma sessão

## Dependências
- Esta tabela é referenciada por: (não possui FK apontando para ela)
- Esta tabela depende de: `unidade`, `tenant`, `sistema`, `usuario`, `sessao_usuario`, `saas_entidade`

## Fluxo de utilização dentro do sistema
1. ULID é gerado com carimbo de tempo embutido, permitindo ordenação natural
2. Eventos são registrados com estado_processamento=PENDENTE
3. Processador central muda para PROCESSANDO, PROCESSADO ou ERRO
4. Estado CONFLITO indica divergência entre ambientes edge
5. Estado REPROCESSAR indica necessidade de reprocessamento devido a falhas
6. O ULID permite ordenação consistente de eventos em sistemas distribuídos
7. Usado para reconciliação de dados entre múltiplos ambientes
8. Base para sistemas de event sourcing com ordenação temporal garantida