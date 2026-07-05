# MD-ffa_demandas_externas-colunas — Colunas

## Tabela: `ffa_demandas_externas`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id` | bigint | NOT NULL AUTO_INCREMENT |
| `id_atendimento` | bigint | unsigned NOT NULL |
| `tipo_demanda` | enum('RX_EXTERNO','MEDICACAO_EXTERNA','EXAME_EXTERNO','OUTROS') | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL |
| `descricao` | text | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci |
| `profissional_externo` | varchar(255) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL |
| `status` | enum('PENDENTE','REALIZADO','CANCELADO') | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT 'PENDENTE' |
| `criado_em` | datetime | DEFAULT CURRENT_TIMESTAMP |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id`),
KEY `fk_demanda_atendimento` (`id_atendimento`)
/*!40000 ALTER TABLE `ffa_demandas_externas` DISABLE KEYS */;
/*!40000 ALTER TABLE `ffa_demandas_externas` ENABLE KEYS */;
