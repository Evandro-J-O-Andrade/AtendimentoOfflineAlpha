# MD-auditoria_estoque_sanitario-colunas — Colunas

## Tabela: `auditoria_estoque_sanitario`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id` | bigint | NOT NULL AUTO_INCREMENT |
| `id_farmaco` | bigint | NOT NULL |
| `id_lote` | bigint | NOT NULL |
| `id_local` | int | NOT NULL |
| `quantidade` | int | NOT NULL |
| `nivel_risco` | enum('OK','CRITICO','VENCIDO') | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL |
| `criado_por` | bigint | NOT NULL |
| `criado_em` | datetime | NOT NULL DEFAULT CURRENT_TIMESTAMP |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id`)
/*!40000 ALTER TABLE `auditoria_estoque_sanitario` DISABLE KEYS */;
/*!40000 ALTER TABLE `auditoria_estoque_sanitario` ENABLE KEYS */;
