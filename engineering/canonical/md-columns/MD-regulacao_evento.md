# MD-regulacao_evento-colunas — Colunas

## Tabela: `regulacao_evento`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_regulacao` | bigint | unsigned NOT NULL AUTO_INCREMENT |
| `id_unidade` | bigint | unsigned NOT NULL |
| `id_ffa` | bigint | unsigned NOT NULL |
| `status` | enum('SOLICITADO','EM_ANALISE','AUTORIZADO','NEGADO','TRANSFERIDO') | COLLATE utf8mb4_unicode_ci NOT NULL |
| `destino_unidade` | bigint | unsigned DEFAULT NULL |
| `tipo_regulacao` | varchar(50) | COLLATE utf8mb4_unicode_ci DEFAULT NULL |
| `observacao` | text | COLLATE utf8mb4_unicode_ci |
| `criado_em` | datetime(6) | DEFAULT CURRENT_TIMESTAMP(6) |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_regulacao`),
KEY `idx_reg_ffa` (`id_ffa`),
KEY `fk_regulacao_evento_entidade` (`id_entidade`),
CONSTRAINT `fk_reg_ffa` FOREIGN KEY (`id_ffa`) REFERENCES `ffa` (`id_ffa`),
CONSTRAINT `fk_regulacao_evento_entidade` FOREIGN KEY (`id_entidade`) REFERENCES `saas_entidade` (`id_entidade`)
/*!40000 ALTER TABLE `regulacao_evento` DISABLE KEYS */;
/*!40000 ALTER TABLE `regulacao_evento` ENABLE KEYS */;
