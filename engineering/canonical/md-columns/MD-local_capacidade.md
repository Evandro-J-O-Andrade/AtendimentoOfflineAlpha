# MD-local_capacidade-colunas — Colunas

## Tabela: `local_capacidade`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_local_capacidade` | bigint | NOT NULL AUTO_INCREMENT |
| `id_local` | bigint | NOT NULL |
| `capacidade_maxima` | int | DEFAULT NULL |
| `ocupacao_atual` | int | DEFAULT '0' |
| `atualizado_em` | datetime(6) | DEFAULT NULL |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_local_capacidade`)
/*!40000 ALTER TABLE `local_capacidade` DISABLE KEYS */;
/*!40000 ALTER TABLE `local_capacidade` ENABLE KEYS */;
