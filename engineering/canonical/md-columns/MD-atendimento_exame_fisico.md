# MD-atendimento_exame_fisico-colunas — Colunas

## Tabela: `atendimento_exame_fisico`

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
KEY `fk_atendimento_exame_fisico_atendimento` (`id_atendimento`),
KEY `fk_aexf_unid` (`id_unidade`),
KEY `fk_atendimento_exame_fisico_entidade` (`id_entidade`),
CONSTRAINT `fk_aexf_unid` FOREIGN KEY (`id_unidade`) REFERENCES `unidade` (`id_unidade`),
CONSTRAINT `fk_atendimento_exame_fisico_atendimento` FOREIGN KEY (`id_atendimento`) REFERENCES `atendimento` (`id_atendimento`) ON DELETE CASCADE ON UPDATE CASCADE,
CONSTRAINT `fk_atendimento_exame_fisico_entidade` FOREIGN KEY (`id_entidade`) REFERENCES `saas_entidade` (`id_entidade`)
/*!40000 ALTER TABLE `atendimento_exame_fisico` DISABLE KEYS */;
/*!40000 ALTER TABLE `atendimento_exame_fisico` ENABLE KEYS */;
