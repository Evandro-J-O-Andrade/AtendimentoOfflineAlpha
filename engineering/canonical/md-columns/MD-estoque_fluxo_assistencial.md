# MD-estoque_fluxo_assistencial-colunas — Colunas

## Tabela: `estoque_fluxo_assistencial`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id` | bigint | NOT NULL AUTO_INCREMENT |
| `id_paciente` | bigint | NOT NULL |
| `id_ffaitem` | bigint | NOT NULL |
| `id_movimento` | bigint | NOT NULL |
| `id_movimento_item` | bigint | NOT NULL |
| `id_produto` | bigint | NOT NULL |
| `id_lote` | bigint | NOT NULL |
| `quantidade` | decimal(10,3) | NOT NULL |
| `hash_execucao` | char(64) | NOT NULL |
| `criado_em` | datetime | NOT NULL DEFAULT CURRENT_TIMESTAMP |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id`),
UNIQUE KEY `uk_ffaitem_movimento` (`id_ffaitem`,`id_movimento_item`),
UNIQUE KEY `uk_hash_execucao` (`hash_execucao`),
KEY `idx_paciente` (`id_paciente`),
KEY `idx_lote` (`id_lote`),
KEY `idx_produto` (`id_produto`),
KEY `idx_movimento` (`id_movimento`)
/*!40000 ALTER TABLE `estoque_fluxo_assistencial` DISABLE KEYS */;
/*!40000 ALTER TABLE `estoque_fluxo_assistencial` ENABLE KEYS */;
