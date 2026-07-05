# MD-assistencial_minipal_metric-colunas — Colunas

## Tabela: `assistencial_minipal_metric`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_metric` | bigint | NOT NULL AUTO_INCREMENT |
| `id_sistema` | bigint | NOT NULL |
| `id_unidade` | bigint | unsigned NOT NULL |
| `score_global` | decimal(10,4) | DEFAULT '0.0000' |
| `risco_fila` | decimal(10,4) | DEFAULT '0.0000' |
| `risco_evasao` | decimal(10,4) | DEFAULT '0.0000' |
| `risco_retry` | decimal(10,4) | DEFAULT '0.0000' |
| `estabilidade_runtime` | decimal(10,4) | DEFAULT '0.0000' |
| `estado_rede` | varchar(40) | DEFAULT 'NORMAL' |
| `criado_em` | datetime(6) | DEFAULT CURRENT_TIMESTAMP(6) |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_metric`),
KEY `idx_minipal_lookup` (`id_sistema`,`criado_em`)
/*!40000 ALTER TABLE `assistencial_minipal_metric` DISABLE KEYS */;
/*!40000 ALTER TABLE `assistencial_minipal_metric` ENABLE KEYS */;
