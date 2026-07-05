# MD-atendimento_profissional-colunas — Colunas

## Tabela: `atendimento_profissional`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id` | bigint | NOT NULL AUTO_INCREMENT |
| `id_atendimento` | bigint | unsigned NOT NULL |
| `id_usuario` | bigint | NOT NULL |
| `papel` | enum('MEDICO','ENFERMEIRO','TECNICO','OUTROS') | DEFAULT NULL |
| `criado_em` | datetime(6) | NOT NULL |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id`),
KEY `fk_atendimento_profissional_atendimento` (`id_atendimento`),
KEY `idx_aprof_ent` (`id_entidade`),
CONSTRAINT `fk_atendimento_profissional_atendimento` FOREIGN KEY (`id_atendimento`) REFERENCES `atendimento` (`id_atendimento`) ON DELETE CASCADE ON UPDATE CASCADE,
CONSTRAINT `fk_atendimento_profissional_entidade` FOREIGN KEY (`id_entidade`) REFERENCES `saas_entidade` (`id_entidade`)
/*!40000 ALTER TABLE `atendimento_profissional` DISABLE KEYS */;
/*!40000 ALTER TABLE `atendimento_profissional` ENABLE KEYS */;
