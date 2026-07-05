# MD-ffa_substatus-colunas — Colunas

## Tabela: `ffa_substatus`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id` | bigint | NOT NULL AUTO_INCREMENT |
| `id_ffa` | bigint | NOT NULL |
| `categoria` | enum('MEDICACAO','FARMACIA','OBSERVACAO','RX','ECG','COLETA','OUTRO') | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL |
| `status` | varchar(50) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL |
| `ativo` | tinyint(1) | DEFAULT '1' |
| `criado_em` | datetime | DEFAULT CURRENT_TIMESTAMP |
| `finalizado_em` | datetime | DEFAULT NULL |
| `id_usuario` | bigint | DEFAULT NULL |
| `observacao` | text | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id`),
KEY `id_usuario` (`id_usuario`),
KEY `idx_ffa_categoria` (`id_ffa`,`categoria`,`ativo`),
CONSTRAINT `ffa_substatus_ibfk_2` FOREIGN KEY (`id_usuario`) REFERENCES `usuario` (`id_usuario`) ON DELETE SET NULL
/*!40000 ALTER TABLE `ffa_substatus` DISABLE KEYS */;
/*!40000 ALTER TABLE `ffa_substatus` ENABLE KEYS */;
