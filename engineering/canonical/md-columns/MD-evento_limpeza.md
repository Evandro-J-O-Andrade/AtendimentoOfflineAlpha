# MD-evento_limpeza-colunas — Colunas

## Tabela: `evento_limpeza`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_evento` | bigint | NOT NULL AUTO_INCREMENT |
| `id_setor` | int | NOT NULL |
| `tipo_evento` | enum('LIMPEZA_ROTINA','LIMPEZA_TERMINAL','REPOSICAO_HIGIENE','INTERCORRENCIA','CONTAMINACAO') | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL |
| `registrado_por` | bigint | NOT NULL |
| `observacao` | text | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci |
| `criado_em` | datetime | DEFAULT CURRENT_TIMESTAMP |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_evento`),
KEY `idx_setor` (`id_setor`)
/*!40000 ALTER TABLE `evento_limpeza` DISABLE KEYS */;
/*!40000 ALTER TABLE `evento_limpeza` ENABLE KEYS */;
