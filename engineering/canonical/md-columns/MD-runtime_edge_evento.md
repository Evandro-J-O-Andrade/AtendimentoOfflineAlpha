# MD-runtime_edge_evento-colunas — Colunas

## Tabela: `runtime_edge_evento`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_evento` | bigint | NOT NULL AUTO_INCREMENT |
| `uuid_evento` | char(36) | NOT NULL |
| `id_sessao_usuario` | bigint | NOT NULL |
| `id_unidade` | bigint | unsigned NOT NULL |
| `id_local` | bigint | DEFAULT NULL |
| `dominio_fluxo` | varchar(50) | NOT NULL |
| `estado_origem` | varchar(50) | NOT NULL |
| `estado_destino` | varchar(50) | NOT NULL |
| `payload_operacional` | json | NOT NULL |
| `metadata_snapshot_hash` | char(64) | NOT NULL |
| `modo_execucao` | enum('ONLINE','OFFLINE') | NOT NULL |
| `status_sync` | enum('PENDENTE','ENVIADO','CONFIRMADO','REJEITADO') | DEFAULT 'PENDENTE' |
| `criado_em` | datetime(6) | DEFAULT CURRENT_TIMESTAMP(6) |
| `sincronizado_em` | datetime(6) | DEFAULT NULL |
| `id_orquestrador` | bigint | NOT NULL |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_evento`),
UNIQUE KEY `uk_runtime_evento_uuid` (`uuid_evento`),
KEY `idx_runtime_evento_sync` (`status_sync`),
KEY `idx_runtime_evento_sessao` (`id_sessao_usuario`),
KEY `idx_evento_orquestrador` (`id_orquestrador`),
KEY `fk_runtime_edge_evento_unidade` (`id_unidade`),
CONSTRAINT `fk_runtime_edge_evento_unidade` FOREIGN KEY (`id_unidade`) REFERENCES `unidade` (`id_unidade`)
/*!40000 ALTER TABLE `runtime_edge_evento` DISABLE KEYS */;
/*!40000 ALTER TABLE `runtime_edge_evento` ENABLE KEYS */;
