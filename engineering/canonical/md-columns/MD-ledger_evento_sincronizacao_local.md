# MD-ledger_evento_sincronizacao_local-colunas — Colunas

## Tabela: `ledger_evento_sincronizacao_local`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_evento` | char(36) | NOT NULL |
| `id_tenant` | bigint | NOT NULL |
| `id_sistema` | bigint | NOT NULL |
| `id_unidade` | bigint | unsigned NOT NULL |
| `id_local_operacional` | bigint | DEFAULT NULL |
| `tipo_evento` | varchar(50) | NOT NULL |
| `subtipo_evento` | varchar(50) | DEFAULT NULL |
| `payload_json` | json | NOT NULL |
| `hash_integridade` | char(64) | NOT NULL |
| `origem_contexto` | enum('LOCAL_EDGE','SYNC_CLOUD') | NOT NULL |
| `estado_sincronizacao` | enum('PENDENTE','ENVIADO','CONFIRMADO','REPROCESSAR','ERRO') | DEFAULT 'PENDENTE' |
| `tentativas_sync` | int | DEFAULT '0' |
| `timestamp_evento` | datetime(6) | NOT NULL |
| `timestamp_registro` | datetime(6) | DEFAULT CURRENT_TIMESTAMP(6) |
| `versao_schema` | int | NOT NULL |
| `criado_em` | datetime(6) | DEFAULT CURRENT_TIMESTAMP(6) |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_evento`),
KEY `idx_ledger_tenant` (`id_tenant`),
KEY `idx_ledger_unidade` (`id_unidade`),
KEY `idx_ledger_local` (`id_local_operacional`),
KEY `idx_ledger_estado_sync` (`estado_sincronizacao`),
KEY `idx_ledger_timestamp_evt` (`timestamp_evento`),
KEY `idx_ledger_tipo_evento` (`tipo_evento`),
CONSTRAINT `fk_ledger_evento_sincronizacao_local_unidade` FOREIGN KEY (`id_unidade`) REFERENCES `unidade` (`id_unidade`)
/*!40000 ALTER TABLE `ledger_evento_sincronizacao_local` DISABLE KEYS */;
/*!40000 ALTER TABLE `ledger_evento_sincronizacao_local` ENABLE KEYS */;
