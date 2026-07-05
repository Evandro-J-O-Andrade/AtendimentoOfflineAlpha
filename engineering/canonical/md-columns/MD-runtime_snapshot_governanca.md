# MD-runtime_snapshot_governanca-colunas — Colunas

## Tabela: `runtime_snapshot_governanca`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_governanca` | bigint | NOT NULL AUTO_INCREMENT |
| `dominio_fluxo` | varchar(50) | NOT NULL |
| `ttl_snapshot_horas` | int | NOT NULL DEFAULT '24' |
| `tolerancia_execucao_horas` | int | NOT NULL DEFAULT '2' |
| `exigir_revalidacao_expirada` | tinyint(1) | DEFAULT '1' |
| `ativo` | tinyint(1) | DEFAULT '1' |
| `criado_em` | datetime(6) | DEFAULT CURRENT_TIMESTAMP(6) |
| `atualizado_em` | datetime(6) | DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP(6) |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_governanca`),
UNIQUE KEY `uk_snapshot_governanca_fluxo` (`dominio_fluxo`)
/*!40000 ALTER TABLE `runtime_snapshot_governanca` DISABLE KEYS */;
/*!40000 ALTER TABLE `runtime_snapshot_governanca` ENABLE KEYS */;
