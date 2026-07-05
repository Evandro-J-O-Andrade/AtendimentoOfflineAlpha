# MD-estoque_execucao_pipeline-colunas — Colunas

## Tabela: `estoque_execucao_pipeline`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `pipeline_hash` | char(64) | NOT NULL |
| `estado` | enum('PROCESSANDO','CONCLUIDO','FALHA') | NOT NULL |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`pipeline_hash`)
/*!40000 ALTER TABLE `estoque_execucao_pipeline` DISABLE KEYS */;
/*!40000 ALTER TABLE `estoque_execucao_pipeline` ENABLE KEYS */;
