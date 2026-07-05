# MD-gpat_item-colunas — Colunas

## Tabela: `gpat_item`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_gpat_item` | bigint | NOT NULL AUTO_INCREMENT |
| `id_gpat` | bigint | NOT NULL |
| `id_farmaco` | bigint | NOT NULL |
| `quantidade_total` | decimal(10,2) | NOT NULL |
| `unidade_medida` | varchar(20) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL |
| `posologia` | text | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci |
| `dias` | int | DEFAULT NULL |
| `observacao` | text | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci |
| `status` | enum('ATIVO','SUSPENSO','ENCERRADO') | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'ATIVO' |
| `criado_em` | datetime | NOT NULL DEFAULT CURRENT_TIMESTAMP |
| `atualizado_em` | datetime | NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_gpat_item`),
KEY `idx_gpat_item_gpat` (`id_gpat`),
KEY `idx_gpat_item_farmaco` (`id_farmaco`),
CONSTRAINT `fk_gpat_item_farmaco` FOREIGN KEY (`id_farmaco`) REFERENCES `farmaco` (`id_farmaco`),
CONSTRAINT `fk_gpat_item_gpat` FOREIGN KEY (`id_gpat`) REFERENCES `gpat_atendimento` (`id_gpat`) ON DELETE CASCADE
/*!40000 ALTER TABLE `gpat_item` DISABLE KEYS */;
/*!40000 ALTER TABLE `gpat_item` ENABLE KEYS */;
