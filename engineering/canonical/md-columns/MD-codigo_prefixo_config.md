# MD-codigo_prefixo_config-colunas — Colunas

## Tabela: `codigo_prefixo_config`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_prefixo` | bigint | NOT NULL AUTO_INCREMENT |
| `dominio` | enum('LAB','FARMACIA','ESTOQUE','FATURAMENTO','RH','PATRIMONIO','OUTRO') | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL |
| `prefixo_5` | char(5) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL |
| `id_unidade` | bigint | unsigned NOT NULL |
| `id_local_operacional` | bigint | DEFAULT NULL |
| `id_laboratorio` | bigint | DEFAULT NULL |
| `observacao` | varchar(255) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL |
| `criado_em` | datetime | NOT NULL DEFAULT CURRENT_TIMESTAMP |
| `atualizado_em` | datetime | NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_prefixo`),
UNIQUE KEY `uk_prefixo_escopo` (`dominio`,`prefixo_5`,`id_unidade`,`id_local_operacional`,`id_laboratorio`),
KEY `idx_prefixo_lookup` (`dominio`,`ativo`,`id_unidade`,`id_local_operacional`,`id_laboratorio`)
/*!40000 ALTER TABLE `codigo_prefixo_config` DISABLE KEYS */;
/*!40000 ALTER TABLE `codigo_prefixo_config` ENABLE KEYS */;
