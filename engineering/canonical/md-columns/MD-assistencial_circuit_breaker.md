# MD-assistencial_circuit_breaker-colunas — Colunas

## Tabela: `assistencial_circuit_breaker`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_circuit` | bigint | NOT NULL AUTO_INCREMENT |
| `componente` | varchar(60) | NOT NULL |
| `estado` | enum('FECHADO','ABERTO','MEIO_ABERTO') | DEFAULT 'FECHADO' |
| `falhas_consecutivas` | int | DEFAULT '0' |
| `limite_falha` | int | DEFAULT '5' |
| `atualizado_em` | datetime(6) | DEFAULT CURRENT_TIMESTAMP(6) |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_circuit`),
UNIQUE KEY `uk_circuit_componente` (`componente`)
/*!40000 ALTER TABLE `assistencial_circuit_breaker` DISABLE KEYS */;
/*!40000 ALTER TABLE `assistencial_circuit_breaker` ENABLE KEYS */;
