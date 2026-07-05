# MD-almoxarifado_central-colunas — Colunas

## Tabela: `almoxarifado_central`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id` | bigint | NOT NULL AUTO_INCREMENT |
| `id_produto` | int | NOT NULL |
| `lote` | varchar(50) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL |
| `validade` | date | DEFAULT NULL |
| `quantidade_atual` | int | NOT NULL |
| `quantidade_minima` | int | DEFAULT '100' |
| `nfe_chave_acesso` | varchar(44) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL |
| `id_unidade` | bigint | unsigned DEFAULT NULL |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id`),
KEY `idx_validade` (`validade`)
/*!40000 ALTER TABLE `almoxarifado_central` DISABLE KEYS */;
/*!40000 ALTER TABLE `almoxarifado_central` ENABLE KEYS */;
