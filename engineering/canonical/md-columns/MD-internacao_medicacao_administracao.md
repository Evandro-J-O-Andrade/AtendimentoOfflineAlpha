# MD-internacao_medicacao_administracao-colunas — Colunas

## Tabela: `internacao_medicacao_administracao`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_internacao_medicacao_administracao` | bigint | NOT NULL AUTO_INCREMENT |
| `id_internacao` | bigint | NOT NULL |
| `id_internacao_prescricao_item` | bigint | NOT NULL |
| `data_hora` | datetime | NOT NULL DEFAULT CURRENT_TIMESTAMP |
| `status` | enum('ADMINISTRADO','RECUSADO','SUSPENSO','NAO_DISPONIVEL') | NOT NULL DEFAULT 'ADMINISTRADO' |
| `dose_aplicada` | varchar(60) | DEFAULT NULL |
| `via_administracao` | varchar(60) | DEFAULT NULL |
| `id_usuario_responsavel` | bigint | NOT NULL |
| `id_sessao_usuario` | bigint | DEFAULT NULL |
| `criado_em` | datetime | NOT NULL DEFAULT CURRENT_TIMESTAMP |
| `id_atendimento` | bigint | unsigned NOT NULL |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_internacao_medicacao_administracao`),
KEY `idx_ima_internacao` (`id_internacao`),
KEY `idx_ima_item` (`id_internacao_prescricao_item`),
KEY `idx_ima_data_hora` (`data_hora`),
KEY `idx_ima_usuario` (`id_usuario_responsavel`),
KEY `idx_ima_sessao` (`id_sessao_usuario`),
KEY `fk_internacao_medicacao_administracao_atendimento` (`id_atendimento`),
KEY `idx_int_med_ent` (`id_entidade`),
CONSTRAINT `fk_ima_internacao` FOREIGN KEY (`id_internacao`) REFERENCES `internacao` (`id_internacao`),
CONSTRAINT `fk_ima_item` FOREIGN KEY (`id_internacao_prescricao_item`) REFERENCES `internacao_prescricao_item` (`id_internacao_prescricao_item`),
CONSTRAINT `fk_ima_usuario` FOREIGN KEY (`id_usuario_responsavel`) REFERENCES `usuario` (`id_usuario`),
CONSTRAINT `fk_internacao_medicacao_administracao_atendimento` FOREIGN KEY (`id_atendimento`) REFERENCES `atendimento` (`id_atendimento`) ON DELETE CASCADE ON UPDATE CASCADE,
CONSTRAINT `fk_internacao_medicacao_administracao_entidade` FOREIGN KEY (`id_entidade`) REFERENCES `saas_entidade` (`id_entidade`)
/*!40000 ALTER TABLE `internacao_medicacao_administracao` DISABLE KEYS */;
/*!40000 ALTER TABLE `internacao_medicacao_administracao` ENABLE KEYS */;
