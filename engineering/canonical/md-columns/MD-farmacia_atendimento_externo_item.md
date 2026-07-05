# MD-farmacia_atendimento_externo_item-colunas — Colunas

## Tabela: `farmacia_atendimento_externo_item`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_item` | bigint | NOT NULL AUTO_INCREMENT |
| `id_atendimento` | bigint | NOT NULL |
| `id_farmaco` | bigint | NOT NULL |
| `quantidade_total` | decimal(10,2) | NOT NULL |
| `posologia` | text | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci |
| `dias` | int | DEFAULT NULL |
| `status` | enum('ATIVO','SUSPENSO','CONCLUIDO') | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'ATIVO' |
| `criado_em` | datetime | NOT NULL DEFAULT CURRENT_TIMESTAMP |
| `criado_por` | bigint | NOT NULL |
| `atualizado_em` | datetime | DEFAULT NULL |
| `atualizado_por` | bigint | DEFAULT NULL |
| `id_lote` | bigint | NOT NULL |
| `id_local_estoque` | bigint | NOT NULL |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_item`),
KEY `idx_faei` (`id_atendimento`,`status`),
KEY `fk_faei_farmaco` (`id_farmaco`),
CONSTRAINT `fk_faei_atend` FOREIGN KEY (`id_atendimento`) REFERENCES `farmacia_atendimento_externo` (`id_atendimento`),
CONSTRAINT `fk_faei_farmaco` FOREIGN KEY (`id_farmaco`) REFERENCES `farmaco` (`id_farmaco`)
/*!40000 ALTER TABLE `farmacia_atendimento_externo_item` DISABLE KEYS */;
/*!40000 ALTER TABLE `farmacia_atendimento_externo_item` ENABLE KEYS */;
