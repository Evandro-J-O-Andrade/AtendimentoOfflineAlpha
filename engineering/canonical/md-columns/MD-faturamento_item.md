# MD-faturamento_item-colunas — Colunas

## Tabela: `faturamento_item`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_item` | bigint | NOT NULL AUTO_INCREMENT |
| `origem` | enum('PROCEDIMENTO','EXAME','MEDICACAO','MATERIAL','TAXA','OUTRO') | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL |
| `id_origem` | bigint | NOT NULL |
| `descricao` | varchar(255) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL |
| `quantidade` | decimal(10,2) | DEFAULT '1.00' |
| `valor_unitario` | decimal(10,2) | NOT NULL |
| `valor_total` | decimal(10,2) | NOT NULL |
| `id_ffa` | bigint | DEFAULT NULL |
| `id_internacao` | bigint | DEFAULT NULL |
| `criado_em` | datetime | DEFAULT CURRENT_TIMESTAMP |
| `criado_por` | bigint | NOT NULL |
| `status` | enum('ABERTO','CONSOLIDADO','CANCELADO') | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT 'ABERTO' |
| `id_conta` | bigint | DEFAULT NULL |
| `id_codigo` | bigint | DEFAULT NULL |
| `sistema_codigo` | enum('SUS','TUSS','PROPRIO') | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'PROPRIO' |
| `codigo` | varchar(30) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL |
| `tipo` | enum('PROCEDIMENTO','EXAME','MEDICACAO','DIARIA','HONORARIO','OUTRO') | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'OUTRO' |
| `desconto` | decimal(10,2) | NOT NULL DEFAULT '0.00' |
| `total_linha` | decimal(10,2) | NOT NULL DEFAULT '0.00' |
| `atualizado_em` | datetime | NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_item`),
KEY `idx_fat_item_conta` (`id_conta`),
KEY `idx_fat_item_codigo` (`id_codigo`),
KEY `idx_fat_item_codigo_txt` (`codigo`),
CONSTRAINT `fk_fat_item_codigo` FOREIGN KEY (`id_codigo`) REFERENCES `faturamento_codigo` (`id_codigo`),
CONSTRAINT `fk_fat_item_conta` FOREIGN KEY (`id_conta`) REFERENCES `faturamento_conta` (`id_conta`)
/*!40000 ALTER TABLE `faturamento_item` DISABLE KEYS */;
/*!40000 ALTER TABLE `faturamento_item` ENABLE KEYS */;
