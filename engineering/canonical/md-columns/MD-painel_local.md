# MD-painel_local-colunas — Colunas

## Tabela: `painel_local`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_painel` | bigint | NOT NULL |
| `id_local_operacional` | bigint | NOT NULL |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_painel`,`id_local_operacional`),
KEY `idx_painel_local_local` (`id_local_operacional`),
CONSTRAINT `fk_painel_local_local` FOREIGN KEY (`id_local_operacional`) REFERENCES `local_operacional` (`id_local_operacional`),
CONSTRAINT `fk_painel_local_painel` FOREIGN KEY (`id_painel`) REFERENCES `painel` (`id_painel`)
/*!40000 ALTER TABLE `painel_local` DISABLE KEYS */;
/*!40000 ALTER TABLE `painel_local` ENABLE KEYS */;
