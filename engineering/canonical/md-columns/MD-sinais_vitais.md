# MD-sinais_vitais-colunas — Colunas

## Tabela: `sinais_vitais`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_sinal` | bigint | NOT NULL AUTO_INCREMENT |
| `id_atendimento` | bigint | unsigned NOT NULL |
| `id_usuario` | bigint | NOT NULL |
| `frequencia_cardiaca` | int | DEFAULT NULL |
| `pressao_sistolica` | int | DEFAULT NULL |
| `pressao_diastolica` | int | DEFAULT NULL |
| `temperatura` | decimal(4,2) | DEFAULT NULL |
| `saturacao_o2` | int | DEFAULT NULL |
| `dor` | int | DEFAULT NULL |
| `criado_em` | datetime | DEFAULT CURRENT_TIMESTAMP |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_sinal`),
KEY `fk_sinais_atendimento` (`id_atendimento`)
/*!40000 ALTER TABLE `sinais_vitais` DISABLE KEYS */;
/*!40000 ALTER TABLE `sinais_vitais` ENABLE KEYS */;
