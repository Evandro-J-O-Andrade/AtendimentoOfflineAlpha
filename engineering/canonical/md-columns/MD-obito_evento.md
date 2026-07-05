# MD-obito_evento-colunas — Colunas

## Tabela: `obito_evento`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_obito_evento` | bigint | NOT NULL AUTO_INCREMENT |
| `id_obito` | bigint | NOT NULL |
| `tipo_evento` | enum('REGISTRADO','ATUALIZADO','CANCELADO') | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL |
| `descricao` | text | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci |
| `id_usuario` | bigint | DEFAULT NULL |
| `criado_em` | datetime | NOT NULL DEFAULT CURRENT_TIMESTAMP |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_obito_evento`),
KEY `idx_ob_evt_obito` (`id_obito`),
KEY `idx_ob_evt_tipo` (`tipo_evento`,`criado_em`),
KEY `idx_ob_evt_obito_data` (`id_obito`,`criado_em`),
CONSTRAINT `fk_ob_evt_obito` FOREIGN KEY (`id_obito`) REFERENCES `obito` (`id_obito`)
/*!40000 ALTER TABLE `obito_evento` DISABLE KEYS */;
/*!40000 ALTER TABLE `obito_evento` ENABLE KEYS */;
