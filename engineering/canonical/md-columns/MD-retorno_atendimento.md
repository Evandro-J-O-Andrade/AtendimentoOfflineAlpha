# MD-retorno_atendimento-colunas — Colunas

## Tabela: `retorno_atendimento`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_retorno` | bigint | NOT NULL AUTO_INCREMENT |
| `id_atendimento_origem` | bigint | unsigned NOT NULL |
| `id_atendimento_retorno` | bigint | unsigned NOT NULL |
| `motivo` | text | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci |
| `data_hora` | datetime | DEFAULT CURRENT_TIMESTAMP |
| `id_atendimento` | bigint | unsigned NOT NULL |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_retorno`),
KEY `id_atendimento_origem` (`id_atendimento_origem`),
KEY `id_atendimento_retorno` (`id_atendimento_retorno`),
KEY `fk_retorno_atendimento_atendimento` (`id_atendimento`),
KEY `idx_ret_ent` (`id_entidade`),
CONSTRAINT `fk_retorno_atendimento_atendimento` FOREIGN KEY (`id_atendimento`) REFERENCES `atendimento` (`id_atendimento`) ON DELETE CASCADE ON UPDATE CASCADE,
CONSTRAINT `fk_retorno_atendimento_entidade` FOREIGN KEY (`id_entidade`) REFERENCES `saas_entidade` (`id_entidade`)
/*!40000 ALTER TABLE `retorno_atendimento` DISABLE KEYS */;
/*!40000 ALTER TABLE `retorno_atendimento` ENABLE KEYS */;
