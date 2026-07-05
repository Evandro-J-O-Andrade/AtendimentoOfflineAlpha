# MD-assistencial_raim_metric-colunas — Colunas

## Tabela: `assistencial_raim_metric`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_metric` | bigint | NOT NULL AUTO_INCREMENT |
| `id_sistema` | bigint | NOT NULL |
| `id_unidade` | bigint | unsigned NOT NULL |
| `fila_pressao` | decimal(10,4) | DEFAULT '0.0000' |
| `taxa_evasao` | decimal(10,4) | DEFAULT '0.0000' |
| `saturacao_leito` | decimal(10,4) | DEFAULT '0.0000' |
| `backlog_runtime` | decimal(10,4) | DEFAULT '0.0000' |
| `score_raim` | decimal(10,4) | DEFAULT '0.0000' |
| `alerta_recomendacao` | varchar(255) | DEFAULT NULL |
| `criado_em` | datetime(6) | DEFAULT CURRENT_TIMESTAMP(6) |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_metric`),
KEY `idx_raim_lookup` (`id_sistema`,`criado_em`)
/*!40000 ALTER TABLE `assistencial_raim_metric` DISABLE KEYS */;
/*!40000 ALTER TABLE `assistencial_raim_metric` ENABLE KEYS */;
