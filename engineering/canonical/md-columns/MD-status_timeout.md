# MD-status_timeout-colunas — Colunas

## Tabela: `status_timeout`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `status` | enum('AGUARDANDO_CHAMADA_MEDICO','CHAMANDO_MEDICO','AGUARDANDO_RX','CHAMANDO_RX','AGUARDANDO_MEDICACAO','EM_MEDICACAO') | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL |
| `tempo_max_segundos` | int | NOT NULL |
| `status_fallback` | enum('AGUARDANDO_CHAMADA_MEDICO','AGUARDANDO_RX','AGUARDANDO_MEDICACAO') | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL |
| `ativo` | tinyint(1) | DEFAULT '1' |
| `id_entidade` | bigint | unsigned DEFAULT NULL |

---

## Índices

PRIMARY KEY (`status`)
/*!40000 ALTER TABLE `status_timeout` DISABLE KEYS */;
/*!40000 ALTER TABLE `status_timeout` ENABLE KEYS */;
