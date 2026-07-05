# MD-codigo_externo_map-colunas — Colunas

## Tabela: `codigo_externo_map`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_map` | bigint | NOT NULL AUTO_INCREMENT |
| `id_codigo` | bigint | NOT NULL |
| `dominio` | enum('LAB','FARMACIA','ESTOQUE','FATURAMENTO','RH','PATRIMONIO','OUTRO') | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL |
| `sistema_externo` | varchar(50) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL |
| `codigo_externo` | varchar(80) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL |
| `modo_cadastro` | enum('AUTO','MANUAL') | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'MANUAL' |
| `observacao` | varchar(255) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL |
| `payload` | json | DEFAULT NULL |
| `id_sessao_usuario` | bigint | DEFAULT NULL |
| `criado_em` | datetime | NOT NULL DEFAULT CURRENT_TIMESTAMP |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_map`),
UNIQUE KEY `uk_externo` (`dominio`,`sistema_externo`,`codigo_externo`),
KEY `idx_map_codigo` (`id_codigo`),
KEY `idx_map_lookup` (`dominio`,`sistema_externo`),
KEY `fk_map_sessao` (`id_sessao_usuario`),
CONSTRAINT `fk_map_codigo` FOREIGN KEY (`id_codigo`) REFERENCES `codigo_universal` (`id_codigo`)
/*!40000 ALTER TABLE `codigo_externo_map` DISABLE KEYS */;
/*!40000 ALTER TABLE `codigo_externo_map` ENABLE KEYS */;
