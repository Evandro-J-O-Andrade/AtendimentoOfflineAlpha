# MD-atendimento_sinais_vitais-colunas — Colunas

## Tabela: `atendimento_sinais_vitais`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id` | bigint | NOT NULL AUTO_INCREMENT |
| `id_atendimento` | bigint | unsigned NOT NULL |
| `id_usuario_registro` | bigint | NOT NULL |
| `pa_sistolica` | int | DEFAULT NULL |
| `pa_diastolica` | int | DEFAULT NULL |
| `frequencia_cardiaca` | int | DEFAULT NULL |
| `frequencia_respiratoria` | int | DEFAULT NULL |
| `temperatura` | decimal(4,1) | DEFAULT NULL |
| `saturacao_o2` | int | DEFAULT NULL |
| `hgt` | int | DEFAULT NULL |
| `data_registro` | datetime | DEFAULT CURRENT_TIMESTAMP |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id`),
KEY `fk_sv_atendimento` (`id_atendimento`),
KEY `idx_asv_ent` (`id_entidade`),
CONSTRAINT `fk_atendimento_sinais_vitais_atendimento` FOREIGN KEY (`id_atendimento`) REFERENCES `atendimento` (`id_atendimento`) ON DELETE CASCADE ON UPDATE CASCADE,
CONSTRAINT `fk_atendimento_sinais_vitais_entidade` FOREIGN KEY (`id_entidade`) REFERENCES `saas_entidade` (`id_entidade`)
/*!40000 ALTER TABLE `atendimento_sinais_vitais` DISABLE KEYS */;
/*!40000 ALTER TABLE `atendimento_sinais_vitais` ENABLE KEYS */;
