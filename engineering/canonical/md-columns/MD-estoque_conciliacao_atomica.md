# MD-estoque_conciliacao_atomica-colunas — Colunas

## Tabela: `estoque_conciliacao_atomica`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id` | bigint | NOT NULL AUTO_INCREMENT |
| `id_movimento` | bigint | NOT NULL |
| `id_movimento_item` | bigint | NOT NULL |
| `id_ledger` | bigint | NOT NULL |
| `id_fluxo_assistencial` | bigint | DEFAULT NULL |
| `hash_execucao` | char(64) | NOT NULL |
| `estado_conciliacao` | enum('PENDENTE','OK','DIVERGENTE','REPROCESSAR') | NOT NULL DEFAULT 'PENDENTE' |
| `divergencia_quantidade` | decimal(10,3) | DEFAULT NULL |
| `divergencia_valor` | decimal(10,2) | DEFAULT NULL |
| `validado_em` | datetime | DEFAULT NULL |
| `criado_em` | datetime | NOT NULL DEFAULT CURRENT_TIMESTAMP |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id`),
UNIQUE KEY `uk_movimento_item` (`id_movimento_item`),
UNIQUE KEY `uk_hash_execucao` (`hash_execucao`),
KEY `idx_movimento` (`id_movimento`),
KEY `idx_fluxo` (`id_fluxo_assistencial`),
KEY `idx_estado` (`estado_conciliacao`)
/*!40000 ALTER TABLE `estoque_conciliacao_atomica` DISABLE KEYS */;
/*!40000 ALTER TABLE `estoque_conciliacao_atomica` ENABLE KEYS */;
