# MD-internacao_prescricao-colunas — Colunas

## Tabela: `internacao_prescricao`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_internacao_prescricao` | bigint | NOT NULL AUTO_INCREMENT |
| `id_internacao` | bigint | NOT NULL |
| `data_prescricao` | datetime | NOT NULL DEFAULT CURRENT_TIMESTAMP |
| `status` | enum('ATIVA','SUSPENSA','ENCERRADA') | NOT NULL DEFAULT 'ATIVA' |
| `id_usuario_prescritor` | bigint | NOT NULL |
| `id_sessao_usuario` | bigint | DEFAULT NULL |
| `criado_em` | datetime | NOT NULL DEFAULT CURRENT_TIMESTAMP |
| `atualizado_em` | datetime | DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP |
| `id_atendimento` | bigint | unsigned NOT NULL |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_internacao_prescricao`),
KEY `idx_ip_internacao` (`id_internacao`),
KEY `idx_ip_data` (`data_prescricao`),
KEY `idx_ip_status` (`status`),
KEY `idx_ip_usuario` (`id_usuario_prescritor`),
KEY `idx_ip_sessao` (`id_sessao_usuario`),
KEY `fk_internacao_prescricao_atendimento` (`id_atendimento`),
KEY `idx_int_presc_ent` (`id_entidade`),
CONSTRAINT `fk_internacao_prescricao_atendimento` FOREIGN KEY (`id_atendimento`) REFERENCES `atendimento` (`id_atendimento`) ON DELETE CASCADE ON UPDATE CASCADE,
CONSTRAINT `fk_internacao_prescricao_entidade` FOREIGN KEY (`id_entidade`) REFERENCES `saas_entidade` (`id_entidade`),
CONSTRAINT `fk_ip_internacao` FOREIGN KEY (`id_internacao`) REFERENCES `internacao` (`id_internacao`),
CONSTRAINT `fk_ip_usuario` FOREIGN KEY (`id_usuario_prescritor`) REFERENCES `usuario` (`id_usuario`)
/*!40000 ALTER TABLE `internacao_prescricao` DISABLE KEYS */;
/*!40000 ALTER TABLE `internacao_prescricao` ENABLE KEYS */;
