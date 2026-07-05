# MD-ledger_global_sincronismo-colunas — Colunas

## Tabela: `ledger_global_sincronismo`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `ulid_evento` | binary(16) | NOT NULL |
| `id_tenant` | bigint | NOT NULL |
| `id_sistema` | bigint | NOT NULL |
| `id_unidade` | bigint | unsigned NOT NULL |
| `id_local_operacional` | bigint | DEFAULT NULL |
| `origem_runtime` | varchar(40) | NOT NULL |
| `contexto_origem` | varchar(50) | DEFAULT NULL |
| `tipo_evento` | varchar(60) | NOT NULL |
| `subtipo_evento` | varchar(60) | DEFAULT NULL |
| `payload_json` | json | NOT NULL |
| `hash_integridade` | char(64) | NOT NULL |
| `data_evento_local` | datetime(6) | NOT NULL |
| `data_evento_central` | datetime(6) | DEFAULT NULL |
| `versao_schema` | int | NOT NULL |
| `estado_processamento` | enum('PENDENTE','PROCESSANDO','PROCESSADO','REPROCESSAR','ERRO','CONFLITO') | DEFAULT 'PENDENTE' |
| `tentativas_sync` | int | DEFAULT '0' |
| `criado_por` | bigint | DEFAULT NULL |
| `id_sessao_usuario` | bigint | DEFAULT NULL |
| `criado_em` | datetime(6) | DEFAULT CURRENT_TIMESTAMP(6) |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`ulid_evento`),
KEY `idx_ledger_tenant` (`id_tenant`),
KEY `idx_ledger_unidade` (`id_unidade`),
KEY `idx_ledger_local` (`id_local_operacional`),
KEY `idx_ledger_estado` (`estado_processamento`),
KEY `idx_ledger_tipo_evt` (`tipo_evento`),
KEY `idx_ledger_runtime` (`origem_runtime`),
KEY `idx_ledger_schema` (`versao_schema`),
KEY `idx_ledger_timestamp` (`data_evento_local`),
CONSTRAINT `fk_ledger_global_sincronismo_unidade` FOREIGN KEY (`id_unidade`) REFERENCES `unidade` (`id_unidade`)
/*!40000 ALTER TABLE `ledger_global_sincronismo` DISABLE KEYS */;
/*!40000 ALTER TABLE `ledger_global_sincronismo` ENABLE KEYS */;
