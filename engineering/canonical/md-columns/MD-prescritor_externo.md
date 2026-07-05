# MD-prescritor_externo-colunas — Colunas

## Tabela: `prescritor_externo`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_prescritor_externo` | bigint | NOT NULL AUTO_INCREMENT |
| `nome` | varchar(150) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL |
| `conselho` | enum('CRM','CRO','COREN','CRF','OUTRO') | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'CRM' |
| `numero_conselho` | varchar(30) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL |
| `uf` | char(2) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL |
| `documento` | varchar(30) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL |
| `telefone` | varchar(30) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL |
| `ativo` | tinyint(1) | NOT NULL DEFAULT '1' |
| `criado_em` | datetime | NOT NULL DEFAULT CURRENT_TIMESTAMP |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_prescritor_externo`),
UNIQUE KEY `uk_prescritor_conselho` (`conselho`,`numero_conselho`,`uf`),
KEY `idx_prescritor_nome` (`nome`)
/*!40000 ALTER TABLE `prescritor_externo` DISABLE KEYS */;
/*!40000 ALTER TABLE `prescritor_externo` ENABLE KEYS */;
