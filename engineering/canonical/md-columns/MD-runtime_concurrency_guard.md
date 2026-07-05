# MD-runtime_concurrency_guard-colunas — Colunas

## Tabela: `runtime_concurrency_guard`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_guard` | bigint | NOT NULL AUTO_INCREMENT |
| `dominio_fluxo` | varchar(50) | NOT NULL |
| `id_recurso` | varchar(100) | NOT NULL |
| `versao_estado` | bigint | NOT NULL |
| `token_execucao` | char(36) | NOT NULL |
| `hash_contexto` | char(64) | NOT NULL |
| `status_guard` | enum('PROVISIONAL','CONFIRMADO','REJEITADO','CONFLITO') | DEFAULT 'PROVISIONAL' |
| `criado_em` | datetime(6) | DEFAULT CURRENT_TIMESTAMP(6) |
| `confirmado_em` | datetime(6) | DEFAULT NULL |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_guard`),
UNIQUE KEY `uk_guard_concurrency` (`dominio_fluxo`,`id_recurso`,`versao_estado`,`token_execucao`),
KEY `idx_guard_status` (`status_guard`)
/*!40000 ALTER TABLE `runtime_concurrency_guard` DISABLE KEYS */;
/*!40000 ALTER TABLE `runtime_concurrency_guard` ENABLE KEYS */;
