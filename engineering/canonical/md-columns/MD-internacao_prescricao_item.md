# MD-internacao_prescricao_item-colunas — Colunas

## Tabela: `internacao_prescricao_item`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_internacao_prescricao_item` | bigint | NOT NULL AUTO_INCREMENT |
| `id_internacao_prescricao` | bigint | NOT NULL |
| `tipo` | enum('MEDICAMENTO','DIETA','CUIDADO','OUTRO') | NOT NULL |
| `descricao` | varchar(255) | NOT NULL |
| `dosagem` | varchar(60) | DEFAULT NULL |
| `frequencia` | varchar(60) | DEFAULT NULL |
| `via_administracao` | varchar(60) | DEFAULT NULL |
| `inicio_em` | datetime | DEFAULT NULL |
| `fim_em` | datetime | DEFAULT NULL |
| `status` | enum('ATIVO','SUSPENSO','ENCERRADO') | NOT NULL DEFAULT 'ATIVO' |
| `criado_em` | datetime | NOT NULL DEFAULT CURRENT_TIMESTAMP |
| `id_atendimento` | bigint | unsigned NOT NULL |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_internacao_prescricao_item`),
KEY `idx_ipi_prescricao` (`id_internacao_prescricao`),
KEY `idx_ipi_tipo` (`tipo`),
KEY `idx_ipi_status` (`status`),
KEY `fk_internacao_prescricao_item_atendimento` (`id_atendimento`),
KEY `idx_int_prescitem_ent` (`id_entidade`),
CONSTRAINT `fk_internacao_prescricao_item_atendimento` FOREIGN KEY (`id_atendimento`) REFERENCES `atendimento` (`id_atendimento`) ON DELETE CASCADE ON UPDATE CASCADE,
CONSTRAINT `fk_internacao_prescricao_item_entidade` FOREIGN KEY (`id_entidade`) REFERENCES `saas_entidade` (`id_entidade`),
CONSTRAINT `fk_ipi_prescricao` FOREIGN KEY (`id_internacao_prescricao`) REFERENCES `internacao_prescricao` (`id_internacao_prescricao`)
/*!40000 ALTER TABLE `internacao_prescricao_item` DISABLE KEYS */;
/*!40000 ALTER TABLE `internacao_prescricao_item` ENABLE KEYS */;
