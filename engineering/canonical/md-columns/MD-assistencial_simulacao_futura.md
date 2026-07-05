# MD-assistencial_simulacao_futura-colunas — Colunas

## Tabela: `assistencial_simulacao_futura`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_simulacao` | bigint | NOT NULL AUTO_INCREMENT |
| `horizonte_minutos` | int | NOT NULL |
| `carga_prevista` | decimal(10,4) | DEFAULT NULL |
| `risco_conflito_federado` | decimal(10,4) | DEFAULT NULL |
| `risco_backlog` | decimal(10,4) | DEFAULT NULL |
| `recomendacao_runtime` | varchar(200) | DEFAULT NULL |
| `criado_em` | datetime(6) | DEFAULT CURRENT_TIMESTAMP(6) |
| `id_atendimento` | bigint | unsigned NOT NULL |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_simulacao`),
KEY `idx_simulacao_horizonte` (`horizonte_minutos`),
KEY `fk_assistencial_simulacao_futura_atendimento` (`id_atendimento`),
KEY `idx_asf_ent` (`id_entidade`),
CONSTRAINT `fk_assistencial_simulacao_futura_atendimento` FOREIGN KEY (`id_atendimento`) REFERENCES `atendimento` (`id_atendimento`) ON DELETE CASCADE ON UPDATE CASCADE,
CONSTRAINT `fk_assistencial_simulacao_futura_entidade` FOREIGN KEY (`id_entidade`) REFERENCES `saas_entidade` (`id_entidade`)
/*!40000 ALTER TABLE `assistencial_simulacao_futura` DISABLE KEYS */;
/*!40000 ALTER TABLE `assistencial_simulacao_futura` ENABLE KEYS */;
