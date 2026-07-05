# MD-atendimento_prescricao-colunas — Colunas

## Tabela: `atendimento_prescricao`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id` | bigint | NOT NULL AUTO_INCREMENT |
| `id_unidade` | bigint | unsigned NOT NULL |
| `id_ffa` | bigint | NOT NULL |
| `id_usuario` | bigint | NOT NULL |
| `id_sessao_usuario` | bigint | NOT NULL |
| `medicamento` | varchar(255) | NOT NULL |
| `via_administracao` | varchar(50) | DEFAULT NULL |
| `ip_origem` | varchar(45) | DEFAULT NULL |
| `device_info` | varchar(255) | DEFAULT NULL |
| `criado_em` | datetime(6) | DEFAULT NULL |
| `id_entidade` | bigint | unsigned NOT NULL |
| `id_atendimento` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id`),
KEY `fk_atendimento_prescricao_atendimento` (`id_atendimento`),
KEY `fk_apresc_unid` (`id_unidade`),
KEY `fk_atendimento_prescricao_entidade` (`id_entidade`),
CONSTRAINT `fk_apresc_unid` FOREIGN KEY (`id_unidade`) REFERENCES `unidade` (`id_unidade`),
CONSTRAINT `fk_atendimento_prescricao_atendimento` FOREIGN KEY (`id_atendimento`) REFERENCES `atendimento` (`id_atendimento`) ON DELETE CASCADE ON UPDATE CASCADE,
CONSTRAINT `fk_atendimento_prescricao_entidade` FOREIGN KEY (`id_entidade`) REFERENCES `saas_entidade` (`id_entidade`)
/*!40000 ALTER TABLE `atendimento_prescricao` DISABLE KEYS */;
/*!40000 ALTER TABLE `atendimento_prescricao` ENABLE KEYS */;
