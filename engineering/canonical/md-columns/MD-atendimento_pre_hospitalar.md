# MD-atendimento_pre_hospitalar-colunas — Colunas

## Tabela: `atendimento_pre_hospitalar`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_pre_hospitalar` | bigint | unsigned NOT NULL AUTO_INCREMENT |
| `id_atendimento` | bigint | unsigned NOT NULL |
| `tipo_intervencao` | enum('SAMU','UBS','REMOCAO','FARMACIA') | COLLATE utf8mb4_unicode_ci NOT NULL |
| `descricao` | text | COLLATE utf8mb4_unicode_ci |
| `inicio_em` | datetime(6) | DEFAULT NULL |
| `fim_em` | datetime(6) | DEFAULT NULL |
| `criado_em` | datetime(6) | NOT NULL DEFAULT CURRENT_TIMESTAMP(6) |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_pre_hospitalar`),
KEY `idx_pre_hosp_atendimento` (`id_atendimento`),
KEY `idx_aph_ent` (`id_entidade`),
CONSTRAINT `fk_atendimento_pre_hospitalar_atendimento` FOREIGN KEY (`id_atendimento`) REFERENCES `atendimento` (`id_atendimento`) ON DELETE CASCADE ON UPDATE CASCADE,
CONSTRAINT `fk_atendimento_pre_hospitalar_entidade` FOREIGN KEY (`id_entidade`) REFERENCES `saas_entidade` (`id_entidade`),
CONSTRAINT `fk_pre_hosp_atendimento` FOREIGN KEY (`id_atendimento`) REFERENCES `atendimento` (`id_atendimento`)
/*!40000 ALTER TABLE `atendimento_pre_hospitalar` DISABLE KEYS */;
/*!40000 ALTER TABLE `atendimento_pre_hospitalar` ENABLE KEYS */;
