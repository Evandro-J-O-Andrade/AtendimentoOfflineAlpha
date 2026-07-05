# MD-consumo_limpeza-colunas — Colunas

## Tabela: `consumo_limpeza`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_consumo` | bigint | NOT NULL AUTO_INCREMENT |
| `id_setor` | int | NOT NULL COMMENT 'Setor onde ocorreu o consumo' |
| `id_produto` | bigint | NOT NULL COMMENT 'Produto de limpeza' |
| `quantidade` | decimal(10,2) | NOT NULL |
| `unidade` | varchar(20) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT 'UN' |
| `consumido_em` | datetime | DEFAULT CURRENT_TIMESTAMP |
| `registrado_por` | bigint | NOT NULL COMMENT 'Usuário da limpeza' |
| `motivo` | enum('ROTINA','REPOSICAO','CONTAMINACAO','INTERCORRENCIA','OUTRO') | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT 'ROTINA' |
| `observacao` | text | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_consumo`),
KEY `idx_setor` (`id_setor`),
KEY `idx_produto` (`id_produto`)
/*!40000 ALTER TABLE `consumo_limpeza` DISABLE KEYS */;
/*!40000 ALTER TABLE `consumo_limpeza` ENABLE KEYS */;
