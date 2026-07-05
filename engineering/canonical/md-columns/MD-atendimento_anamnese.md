# MD-atendimento_anamnese-colunas — Colunas

## Tabela: `atendimento_anamnese`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id` | bigint | NOT NULL AUTO_INCREMENT |
| `id_unidade` | bigint | unsigned NOT NULL |
| `id_ffa` | bigint | NOT NULL |
| `id_usuario` | bigint | NOT NULL |
| `id_sessao_usuario` | bigint | NOT NULL |
| `ip_origem` | varchar(45) | DEFAULT NULL |
| `device_info` | varchar(255) | DEFAULT NULL |
| `criado_em` | datetime(6) | DEFAULT NULL |
| `id_entidade` | bigint | unsigned NOT NULL |
| `id_atendimento` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id`),
KEY `idx_ffa` (`id_ffa`),
KEY `fk_atendimento_anamnese_atendimento` (`id_atendimento`),
KEY `fk_aanam_unid` (`id_unidade`),
KEY `fk_atendimento_anamnese_entidade` (`id_entidade`),
CONSTRAINT `fk_aanam_unid` FOREIGN KEY (`id_unidade`) REFERENCES `unidade` (`id_unidade`),
CONSTRAINT `fk_anamnese_atend` FOREIGN KEY (`id_atendimento`) REFERENCES `atendimento` (`id_atendimento`) ON DELETE RESTRICT ON UPDATE CASCADE,
CONSTRAINT `fk_atendimento_anamnese_atendimento` FOREIGN KEY (`id_atendimento`) REFERENCES `atendimento` (`id_atendimento`) ON DELETE CASCADE ON UPDATE CASCADE,
CONSTRAINT `fk_atendimento_anamnese_entidade` FOREIGN KEY (`id_entidade`) REFERENCES `saas_entidade` (`id_entidade`)
/*!40000 ALTER TABLE `atendimento_anamnese` DISABLE KEYS */;
/*!40000 ALTER TABLE `atendimento_anamnese` ENABLE KEYS */;
