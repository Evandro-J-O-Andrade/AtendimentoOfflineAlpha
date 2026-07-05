# MD-schema_patch_execucao-colunas — Colunas

## Tabela: `schema_patch_execucao`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_patch_execucao` | bigint | NOT NULL AUTO_INCREMENT |
| `patch_nome` | varchar(120) | COLLATE utf8mb4_unicode_ci NOT NULL |
| `hash_patch` | varchar(128) | COLLATE utf8mb4_unicode_ci DEFAULT NULL |
| `status_execucao` | enum('SUCESSO','ERRO') | COLLATE utf8mb4_unicode_ci NOT NULL |
| `detalhes` | json | DEFAULT NULL |
| `executado_em` | datetime | NOT NULL DEFAULT CURRENT_TIMESTAMP |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_patch_execucao`),
KEY `idx_patch_nome_data` (`patch_nome`,`executado_em`)
/*!40000 ALTER TABLE `schema_patch_execucao` DISABLE KEYS */;
/*!40000 ALTER TABLE `schema_patch_execucao` ENABLE KEYS */;
