# MD-farmaco_movimentacao-colunas — Colunas

## Tabela: `farmaco_movimentacao`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_movimentacao` | bigint | NOT NULL AUTO_INCREMENT |
| `id_farmaco` | bigint | NOT NULL |
| `id_lote` | bigint | NOT NULL |
| `id_cidade` | bigint | NOT NULL |
| `tipo` | enum('ENTRADA','SAIDA') | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL |
| `quantidade` | int | NOT NULL |
| `origem` | enum('COMPRA','TRANSFERENCIA','PACIENTE','AJUSTE','PDV') | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL |
| `id_ffa` | bigint | DEFAULT NULL |
| `observacao` | varchar(255) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL |
| `realizado_por` | bigint | NOT NULL |
| `data_mov` | datetime | NOT NULL DEFAULT CURRENT_TIMESTAMP |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_movimentacao`),
KEY `fk_mov_farmaco` (`id_farmaco`),
KEY `fk_mov_lote` (`id_lote`),
CONSTRAINT `fk_mov_farmaco` FOREIGN KEY (`id_farmaco`) REFERENCES `farmaco` (`id_farmaco`),
CONSTRAINT `fk_mov_lote` FOREIGN KEY (`id_lote`) REFERENCES `farmaco_lote` (`id_lote`)
/*!40000 ALTER TABLE `farmaco_movimentacao` DISABLE KEYS */;
/*!40000 ALTER TABLE `farmaco_movimentacao` ENABLE KEYS */;
