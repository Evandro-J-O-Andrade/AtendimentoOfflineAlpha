# MD-atendimento_movimentacao-colunas — Colunas

## Tabela: `atendimento_movimentacao`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_mov` | bigint | NOT NULL AUTO_INCREMENT |
| `id_atendimento` | bigint | unsigned NOT NULL |
| `de_local` | int | DEFAULT NULL |
| `para_local` | int | DEFAULT NULL |
| `id_usuario` | bigint | DEFAULT NULL |
| `motivo` | varchar(255) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL |
| `data_hora` | datetime | DEFAULT CURRENT_TIMESTAMP |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_mov`),
KEY `id_atendimento` (`id_atendimento`),
KEY `id_usuario` (`id_usuario`),
KEY `idx_amov_ent` (`id_entidade`),
CONSTRAINT `atendimento_movimentacao_ibfk_2` FOREIGN KEY (`id_usuario`) REFERENCES `usuario` (`id_usuario`),
CONSTRAINT `fk_atendimento_movimentacao_atendimento` FOREIGN KEY (`id_atendimento`) REFERENCES `atendimento` (`id_atendimento`) ON DELETE CASCADE ON UPDATE CASCADE,
CONSTRAINT `fk_atendimento_movimentacao_entidade` FOREIGN KEY (`id_entidade`) REFERENCES `saas_entidade` (`id_entidade`)
/*!40000 ALTER TABLE `atendimento_movimentacao` DISABLE KEYS */;
/*!40000 ALTER TABLE `atendimento_movimentacao` ENABLE KEYS */;
