# MD-internacao_movimentacao-colunas — Colunas

## Tabela: `internacao_movimentacao`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id` | bigint | NOT NULL AUTO_INCREMENT |
| `id_internacao` | bigint | NOT NULL |
| `id_leito_origem` | bigint | DEFAULT NULL |
| `id_leito_destino` | bigint | NOT NULL |
| `id_usuario_transferencia` | bigint | NOT NULL |
| `data_movimentacao` | datetime | DEFAULT CURRENT_TIMESTAMP |
| `motivo` | varchar(255) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL |
| `id_sessao_usuario` | bigint | DEFAULT NULL |
| `id_local_operacional` | bigint | DEFAULT NULL |
| `id_unidade` | bigint | unsigned NOT NULL |
| `id_atendimento` | bigint | unsigned NOT NULL |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id`),
KEY `fk_mov_internacao` (`id_internacao`),
KEY `idx_intern_mov_internacao_data` (`id_internacao`,`data_movimentacao`),
KEY `idx_mov_sessao_data` (`id_sessao_usuario`,`data_movimentacao`),
KEY `fk_internacao_movimentacao_unidade` (`id_unidade`),
KEY `fk_internacao_movimentacao_atendimento` (`id_atendimento`),
KEY `idx_int_mov_ent` (`id_entidade`),
CONSTRAINT `fk_internacao_movimentacao_atendimento` FOREIGN KEY (`id_atendimento`) REFERENCES `atendimento` (`id_atendimento`) ON DELETE CASCADE ON UPDATE CASCADE,
CONSTRAINT `fk_internacao_movimentacao_entidade` FOREIGN KEY (`id_entidade`) REFERENCES `saas_entidade` (`id_entidade`),
CONSTRAINT `fk_internacao_movimentacao_unidade` FOREIGN KEY (`id_unidade`) REFERENCES `unidade` (`id_unidade`),
CONSTRAINT `fk_mov_internacao` FOREIGN KEY (`id_internacao`) REFERENCES `internacao` (`id_internacao`)
/*!40000 ALTER TABLE `internacao_movimentacao` DISABLE KEYS */;
/*!40000 ALTER TABLE `internacao_movimentacao` ENABLE KEYS */;
