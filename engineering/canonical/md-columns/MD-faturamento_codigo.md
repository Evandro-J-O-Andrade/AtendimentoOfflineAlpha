# MD-faturamento_codigo-colunas — Colunas

## Tabela: `faturamento_codigo`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_codigo` | bigint | NOT NULL AUTO_INCREMENT |
| `sistema` | enum('SIGTAP','TUSS','CBHPM','INTERNO') | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'INTERNO' |
| `codigo` | varchar(30) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL |
| `tipo` | enum('PROCEDIMENTO','MATERIAL','MEDICAMENTO','TAXA','DIARIA','OUTRO') | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'OUTRO' |
| `descricao` | varchar(255) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL |
| `unidade_medida` | varchar(30) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL |
| `criado_em` | datetime | NOT NULL DEFAULT CURRENT_TIMESTAMP |
| `atualizado_em` | datetime | DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_codigo`),
UNIQUE KEY `uq_faturamento_codigo` (`sistema`,`codigo`)
/*!40000 ALTER TABLE `faturamento_codigo` DISABLE KEYS */;
/*!40000 ALTER TABLE `faturamento_codigo` ENABLE KEYS */;
