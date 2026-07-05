# MD-retry_semantico_controle-colunas — Colunas

## Tabela: `retry_semantico_controle`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_retry` | bigint | NOT NULL AUTO_INCREMENT |
| `id_ffa` | bigint | NOT NULL |
| `evento` | varchar(60) | NOT NULL |
| `versao_logica` | bigint | DEFAULT '1' |
| `tentativas` | int | DEFAULT '0' |
| `max_tentativas` | int | DEFAULT '5' |
| `bloqueado` | tinyint(1) | DEFAULT '0' |
| `ultimo_erro` | varchar(255) | DEFAULT NULL |
| `proxima_tentativa` | datetime(6) | DEFAULT NULL |
| `criado_em` | datetime(6) | DEFAULT CURRENT_TIMESTAMP(6) |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_retry`),
KEY `idx_retry_fila` (`bloqueado`,`proxima_tentativa`)
/*!40000 ALTER TABLE `retry_semantico_controle` DISABLE KEYS */;
/*!40000 ALTER TABLE `retry_semantico_controle` ENABLE KEYS */;
