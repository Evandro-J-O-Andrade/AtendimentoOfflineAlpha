# MD-local_turno-colunas — Colunas

## Tabela: `local_turno`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_local_turno` | bigint | NOT NULL AUTO_INCREMENT |
| `id_local` | bigint | NOT NULL |
| `turno` | varchar(40) | DEFAULT NULL |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_local_turno`)
/*!40000 ALTER TABLE `local_turno` DISABLE KEYS */;
/*!40000 ALTER TABLE `local_turno` ENABLE KEYS */;
