# MD-atendimento_vinculo-colunas — Colunas

## Tabela: `atendimento_vinculo`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id` | bigint | NOT NULL AUTO_INCREMENT |
| `id_ffa` | bigint | NOT NULL |
| `id_atendimento` | bigint | unsigned NOT NULL |
| `criado_em` | datetime(6) | NOT NULL |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id`),
UNIQUE KEY `uk_ffa` (`id_ffa`),
KEY `fk_atendimento_vinculo_atendimento` (`id_atendimento`),
KEY `idx_avinc_ent` (`id_entidade`),
CONSTRAINT `fk_atendimento_vinculo_atendimento` FOREIGN KEY (`id_atendimento`) REFERENCES `atendimento` (`id_atendimento`) ON DELETE CASCADE ON UPDATE CASCADE,
CONSTRAINT `fk_atendimento_vinculo_entidade` FOREIGN KEY (`id_entidade`) REFERENCES `saas_entidade` (`id_entidade`)
/*!40000 ALTER TABLE `atendimento_vinculo` DISABLE KEYS */;
/*!40000 ALTER TABLE `atendimento_vinculo` ENABLE KEYS */;
