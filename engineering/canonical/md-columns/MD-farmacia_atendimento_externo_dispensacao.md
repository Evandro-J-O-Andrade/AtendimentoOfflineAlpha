# MD-farmacia_atendimento_externo_dispensacao-colunas — Colunas

## Tabela: `farmacia_atendimento_externo_dispensacao`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_dispensacao` | bigint | NOT NULL AUTO_INCREMENT |
| `id_item` | bigint | NOT NULL |
| `id_lote` | bigint | NOT NULL |
| `id_local_estoque` | bigint | NOT NULL |
| `quantidade` | decimal(10,2) | NOT NULL |
| `status` | enum('ENTREGUE','CANCELADA') | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'ENTREGUE' |
| `dispensado_em` | datetime | NOT NULL DEFAULT CURRENT_TIMESTAMP |
| `dispensado_por` | bigint | NOT NULL |
| `observacao` | text | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci |
| `id_atendimento` | bigint | unsigned NOT NULL |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_dispensacao`),
KEY `idx_faed` (`id_item`,`status`),
KEY `fk_faed_lote` (`id_lote`),
KEY `fk_faed_local` (`id_local_estoque`),
KEY `fk_farmacia_atendimento_externo_dispensacao_atendimento` (`id_atendimento`),
KEY `idx_far_disp_ent` (`id_entidade`),
CONSTRAINT `fk_faed_item` FOREIGN KEY (`id_item`) REFERENCES `farmacia_atendimento_externo_item` (`id_item`),
CONSTRAINT `fk_faed_local` FOREIGN KEY (`id_local_estoque`) REFERENCES `local_atendimento` (`id_local`),
CONSTRAINT `fk_faed_lote` FOREIGN KEY (`id_lote`) REFERENCES `farmaco_lote` (`id_lote`),
CONSTRAINT `fk_farmacia_atendimento_externo_dispensacao_atendimento` FOREIGN KEY (`id_atendimento`) REFERENCES `atendimento` (`id_atendimento`) ON DELETE CASCADE ON UPDATE CASCADE,
CONSTRAINT `fk_farmacia_atendimento_externo_dispensacao_entidade` FOREIGN KEY (`id_entidade`) REFERENCES `saas_entidade` (`id_entidade`)
/*!40000 ALTER TABLE `farmacia_atendimento_externo_dispensacao` DISABLE KEYS */;
/*!40000 ALTER TABLE `farmacia_atendimento_externo_dispensacao` ENABLE KEYS */;
