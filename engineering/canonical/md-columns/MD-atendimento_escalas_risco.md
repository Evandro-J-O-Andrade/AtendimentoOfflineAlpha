# MD-atendimento_escalas_risco-colunas — Colunas

## Tabela: `atendimento_escalas_risco`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id` | bigint | NOT NULL AUTO_INCREMENT |
| `id_atendimento` | bigint | unsigned NOT NULL |
| `id_usuario` | bigint | NOT NULL |
| `escala_tipo` | enum('MORSE_QUEDA','BRADEN_LESÃO_PELE','GLASGOW') | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL |
| `pontuacao_total` | int | NOT NULL |
| `classificacao_resultado` | varchar(100) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL |
| `data_avaliacao` | datetime | DEFAULT CURRENT_TIMESTAMP |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id`),
KEY `fk_escala_atend` (`id_atendimento`),
KEY `idx_aescr_ent` (`id_entidade`),
CONSTRAINT `fk_atendimento_escalas_risco_atendimento` FOREIGN KEY (`id_atendimento`) REFERENCES `atendimento` (`id_atendimento`) ON DELETE CASCADE ON UPDATE CASCADE,
CONSTRAINT `fk_atendimento_escalas_risco_entidade` FOREIGN KEY (`id_entidade`) REFERENCES `saas_entidade` (`id_entidade`)
/*!40000 ALTER TABLE `atendimento_escalas_risco` DISABLE KEYS */;
/*!40000 ALTER TABLE `atendimento_escalas_risco` ENABLE KEYS */;
