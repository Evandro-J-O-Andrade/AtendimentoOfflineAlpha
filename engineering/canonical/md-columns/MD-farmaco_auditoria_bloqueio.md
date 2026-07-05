# MD-farmaco_auditoria_bloqueio-colunas — Colunas

## Tabela: `farmaco_auditoria_bloqueio`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id` | bigint | NOT NULL AUTO_INCREMENT |
| `id_farmaco` | bigint | NOT NULL |
| `id_lote` | bigint | NOT NULL |
| `id_cidade` | bigint | NOT NULL |
| `quantidade` | int | NOT NULL |
| `id_ffa` | bigint | DEFAULT NULL |
| `usuario` | bigint | NOT NULL |
| `motivo` | varchar(255) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL |
| `criado_em` | datetime | NOT NULL DEFAULT CURRENT_TIMESTAMP |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id`),
KEY `idx_bloq_farmaco` (`id_farmaco`),
KEY `idx_bloq_lote` (`id_lote`),
KEY `idx_bloq_cidade` (`id_cidade`),
KEY `idx_bloq_usuario` (`usuario`)
/*!40000 ALTER TABLE `farmaco_auditoria_bloqueio` DISABLE KEYS */;
/*!40000 ALTER TABLE `farmaco_auditoria_bloqueio` ENABLE KEYS */;
