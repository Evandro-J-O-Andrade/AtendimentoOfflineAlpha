# MD-totem_senha_opcao-colunas — Colunas

## Tabela: `totem_senha_opcao`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_opcao` | bigint | NOT NULL AUTO_INCREMENT |
| `id_painel` | bigint | NOT NULL |
| `codigo` | varchar(30) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL |
| `label` | varchar(80) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL |
| `lane` | varchar(20) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL |
| `tipo_atendimento` | varchar(30) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL |
| `prefixo` | varchar(5) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL |
| `ordem` | int | NOT NULL DEFAULT '1' |
| `ativo` | tinyint(1) | NOT NULL DEFAULT '1' |
| `criado_em` | datetime | NOT NULL DEFAULT CURRENT_TIMESTAMP |
| `id_entidade` | bigint | unsigned DEFAULT NULL |

---

## Índices

PRIMARY KEY (`id_opcao`),
UNIQUE KEY `uk_totem_opcao` (`id_painel`,`codigo`),
KEY `idx_totem_opcao_painel` (`id_painel`),
CONSTRAINT `fk_totem_opcao_painel` FOREIGN KEY (`id_painel`) REFERENCES `painel` (`id_painel`)
/*!40000 ALTER TABLE `totem_senha_opcao` DISABLE KEYS */;
/*!40000 ALTER TABLE `totem_senha_opcao` ENABLE KEYS */;
