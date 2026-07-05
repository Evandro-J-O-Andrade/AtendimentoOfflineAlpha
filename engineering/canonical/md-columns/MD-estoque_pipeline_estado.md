# MD-estoque_pipeline_estado-colunas — Colunas

## Tabela: `estoque_pipeline_estado`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `hash_execucao` | char(64) | NOT NULL |
| `etapa_atual` | varchar(50) | DEFAULT NULL |
| `lease_expira_em` | datetime | DEFAULT NULL |
| `atualizado_em` | datetime | DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`hash_execucao`)
/*!40000 ALTER TABLE `estoque_pipeline_estado` DISABLE KEYS */;
/*!40000 ALTER TABLE `estoque_pipeline_estado` ENABLE KEYS */;
