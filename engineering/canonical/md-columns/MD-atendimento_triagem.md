# MD-atendimento_triagem-colunas — Colunas

## Tabela: `atendimento_triagem`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id` | bigint | NOT NULL AUTO_INCREMENT |
| `id_unidade` | bigint | unsigned NOT NULL |
| `id_ffa` | bigint | NOT NULL |
| `escala_dor` | int | DEFAULT NULL |
| `id_usuario` | bigint | NOT NULL |
| `id_sessao_usuario` | bigint | NOT NULL |
| `peso` | decimal(5,2) | DEFAULT NULL |
| `altura` | decimal(3,2) | DEFAULT NULL |
| `pressao_arterial` | varchar(20) | DEFAULT NULL |
| `frequencia_cardiaca` | int | DEFAULT NULL |
| `temperatura` | decimal(4,2) | DEFAULT NULL |
| `saturacao` | int | DEFAULT NULL |
| `ip_origem` | varchar(45) | DEFAULT NULL |
| `device_info` | varchar(255) | DEFAULT NULL |
| `criado_em` | datetime(6) | DEFAULT NULL |
| `id_entidade` | bigint | unsigned NOT NULL |
| `id_atendimento` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id`),
KEY `idx_ffa` (`id_ffa`),
KEY `fk_atendimento_triagem_atendimento` (`id_atendimento`),
KEY `fk_atri_unid` (`id_unidade`),
KEY `fk_atendimento_triagem_entidade` (`id_entidade`),
CONSTRAINT `fk_atendimento_triagem_atendimento` FOREIGN KEY (`id_atendimento`) REFERENCES `atendimento` (`id_atendimento`) ON DELETE CASCADE ON UPDATE CASCADE,
CONSTRAINT `fk_atendimento_triagem_entidade` FOREIGN KEY (`id_entidade`) REFERENCES `saas_entidade` (`id_entidade`),
CONSTRAINT `fk_atri_unid` FOREIGN KEY (`id_unidade`) REFERENCES `unidade` (`id_unidade`)
/*!40000 ALTER TABLE `atendimento_triagem` DISABLE KEYS */;
/*!40000 ALTER TABLE `atendimento_triagem` ENABLE KEYS */;
