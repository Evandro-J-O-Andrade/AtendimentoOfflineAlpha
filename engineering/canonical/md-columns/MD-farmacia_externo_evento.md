# MD-farmacia_externo_evento-colunas — Colunas

## Tabela: `farmacia_externo_evento`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_evento` | bigint | NOT NULL AUTO_INCREMENT |
| `id_atendimento` | bigint | NOT NULL |
| `tipo` | varchar(40) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL |
| `descricao` | text | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci |
| `criado_em` | datetime | NOT NULL DEFAULT CURRENT_TIMESTAMP |
| `id_usuario` | bigint | DEFAULT NULL |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_evento`),
KEY `idx_fee` (`id_atendimento`,`criado_em`)
/*!40000 ALTER TABLE `farmacia_externo_evento` DISABLE KEYS */;
/*!40000 ALTER TABLE `farmacia_externo_evento` ENABLE KEYS */;
