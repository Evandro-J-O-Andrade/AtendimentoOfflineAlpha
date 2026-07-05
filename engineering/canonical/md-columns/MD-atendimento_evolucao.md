# MD-atendimento_evolucao-colunas — Colunas

## Tabela: `atendimento_evolucao`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id` | bigint | NOT NULL AUTO_INCREMENT |
| `id_unidade` | bigint | unsigned NOT NULL |
| `id_ffa` | bigint | NOT NULL |
| `escala_dor` | int | DEFAULT NULL |
| `id_atendimento` | bigint | unsigned NOT NULL |
| `id_usuario` | bigint | NOT NULL |
| `id_sessao_usuario` | bigint | NOT NULL |
| `tipo_profissional` | enum('MEDICO','ENFERMEIRO','TECNICO','OUTROS') | NOT NULL |
| `texto_evolucao` | text | NOT NULL |
| `hash_seguranca` | char(64) | DEFAULT NULL |
| `ip_origem` | varchar(45) | DEFAULT NULL |
| `device_info` | varchar(255) | DEFAULT NULL |
| `criado_em` | datetime(6) | NOT NULL |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id`),
KEY `idx_ffa` (`id_ffa`),
KEY `idx_usuario` (`id_usuario`),
KEY `idx_sessao` (`id_sessao_usuario`),
KEY `fk_atendimento_evolucao_atendimento` (`id_atendimento`),
KEY `fk_aevol_unid` (`id_unidade`),
KEY `fk_atendimento_evolucao_entidade` (`id_entidade`),
CONSTRAINT `fk_aevol_unid` FOREIGN KEY (`id_unidade`) REFERENCES `unidade` (`id_unidade`),
CONSTRAINT `fk_atendimento_evolucao_atendimento` FOREIGN KEY (`id_atendimento`) REFERENCES `atendimento` (`id_atendimento`) ON DELETE CASCADE ON UPDATE CASCADE,
CONSTRAINT `fk_atendimento_evolucao_entidade` FOREIGN KEY (`id_entidade`) REFERENCES `saas_entidade` (`id_entidade`)
/*!40000 ALTER TABLE `atendimento_evolucao` DISABLE KEYS */;
/*!40000 ALTER TABLE `atendimento_evolucao` ENABLE KEYS */;
