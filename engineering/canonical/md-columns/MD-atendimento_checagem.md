# MD-atendimento_checagem-colunas — Colunas

## Tabela: `atendimento_checagem`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id` | bigint | NOT NULL AUTO_INCREMENT |
| `id_prescricao` | bigint | NOT NULL |
| `horario_planejado` | datetime | NOT NULL |
| `horario_executado` | datetime | DEFAULT NULL |
| `id_enfermeiro` | bigint | DEFAULT NULL |
| `status` | enum('PENDENTE','REALIZADO','RECUSADO','ATRASADO') | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT 'PENDENTE' |
| `motivo_recusa` | varchar(255) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL |
| `id_atendimento` | bigint | unsigned NOT NULL |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id`),
KEY `fk_chec_presc` (`id_prescricao`),
KEY `idx_checagem_horarios` (`horario_planejado`,`status`),
KEY `fk_atendimento_checagem_atendimento` (`id_atendimento`),
KEY `idx_achec_ent` (`id_entidade`),
CONSTRAINT `fk_atendimento_checagem_atendimento` FOREIGN KEY (`id_atendimento`) REFERENCES `atendimento` (`id_atendimento`) ON DELETE CASCADE ON UPDATE CASCADE,
CONSTRAINT `fk_atendimento_checagem_entidade` FOREIGN KEY (`id_entidade`) REFERENCES `saas_entidade` (`id_entidade`),
CONSTRAINT `fk_chec_presc` FOREIGN KEY (`id_prescricao`) REFERENCES `atendimento_prescricao` (`id`)
/*!40000 ALTER TABLE `atendimento_checagem` DISABLE KEYS */;
/*!40000 ALTER TABLE `atendimento_checagem` ENABLE KEYS */;
