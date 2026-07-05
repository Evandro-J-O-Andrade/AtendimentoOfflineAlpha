# MD-gasoterapia_consumo_evento-colunas — Colunas

## Tabela: `gasoterapia_consumo_evento`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_evento` | bigint | NOT NULL AUTO_INCREMENT |
| `id_consumo` | bigint | NOT NULL |
| `evento` | varchar(50) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL |
| `detalhe` | text | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci |
| `id_usuario` | bigint | DEFAULT NULL |
| `id_sessao_usuario` | bigint | DEFAULT NULL |
| `criado_em` | datetime | DEFAULT CURRENT_TIMESTAMP |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_evento`),
KEY `idx_gce_consumo` (`id_consumo`),
KEY `idx_gce_sessao` (`id_sessao_usuario`),
CONSTRAINT `fk_gce_consumo` FOREIGN KEY (`id_consumo`) REFERENCES `gasoterapia_consumo` (`id`)
/*!40000 ALTER TABLE `gasoterapia_consumo_evento` DISABLE KEYS */;
/*!40000 ALTER TABLE `gasoterapia_consumo_evento` ENABLE KEYS */;
