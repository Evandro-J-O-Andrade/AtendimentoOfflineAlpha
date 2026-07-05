# MD-ffa_extra-colunas — Colunas

## Tabela: `ffa_extra`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id` | bigint | NOT NULL AUTO_INCREMENT |
| `id_atendimento` | bigint | DEFAULT NULL |
| `tipo_extra` | enum('MEDICACAO_EXTERNA','RX_EXTERNO','EXAME_EXTERNO','PROCEDIMENTO_AVULSO') | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL |
| `descricao` | text | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci |
| `status` | varchar(45) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT 'PENDENTE' |
| `criado_em` | datetime | DEFAULT CURRENT_TIMESTAMP |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id`)
/*!40000 ALTER TABLE `ffa_extra` DISABLE KEYS */;
/*!40000 ALTER TABLE `ffa_extra` ENABLE KEYS */;
