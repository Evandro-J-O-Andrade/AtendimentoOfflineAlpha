# MD-assistencial_quorum_clinico-colunas — Colunas

## Tabela: `assistencial_quorum_clinico`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_quorum` | bigint | NOT NULL AUTO_INCREMENT |
| `id_ffa` | bigint | NOT NULL |
| `evento` | varchar(60) | NOT NULL |
| `total_unidades_participantes` | int | DEFAULT '1' |
| `unidades_confirmadas` | int | DEFAULT '0' |
| `quorum_valido` | tinyint(1) | DEFAULT '0' |
| `criado_em` | datetime(6) | DEFAULT CURRENT_TIMESTAMP(6) |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_quorum`),
UNIQUE KEY `uk_quorum_ffa_evento` (`id_ffa`,`evento`)
/*!40000 ALTER TABLE `assistencial_quorum_clinico` DISABLE KEYS */;
/*!40000 ALTER TABLE `assistencial_quorum_clinico` ENABLE KEYS */;
