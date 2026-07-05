# MD-faturamento_regras_validacao-colunas — Colunas

## Tabela: `faturamento_regras_validacao`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id` | int | NOT NULL AUTO_INCREMENT |
| `id_atendimento` | bigint | NOT NULL |
| `possui_cid` | tinyint(1) | DEFAULT '0' |
| `possui_cbo` | tinyint(1) | DEFAULT '0' |
| `possui_prescricao` | tinyint(1) | DEFAULT '0' |
| `apto_para_faturar` | tinyint(1) | GENERATED ALWAYS AS (((0 <> `possui_cid`) and (0 <> `possui_cbo`))) STORED |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id`),
UNIQUE KEY `uk_fatura_atend` (`id_atendimento`)
/*!40000 ALTER TABLE `faturamento_regras_validacao` DISABLE KEYS */;
/*!40000 ALTER TABLE `faturamento_regras_validacao` ENABLE KEYS */;
