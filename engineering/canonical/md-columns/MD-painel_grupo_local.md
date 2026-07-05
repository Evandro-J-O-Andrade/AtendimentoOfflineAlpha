# MD-painel_grupo_local-colunas — Colunas

## Tabela: `painel_grupo_local`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_grupo` | bigint | NOT NULL |
| `id_local_operacional` | bigint | NOT NULL |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_grupo`,`id_local_operacional`),
KEY `idx_pgl_local` (`id_local_operacional`),
CONSTRAINT `fk_pgl_grupo` FOREIGN KEY (`id_grupo`) REFERENCES `painel_grupo` (`id_grupo`)
/*!40000 ALTER TABLE `painel_grupo_local` DISABLE KEYS */;
/*!40000 ALTER TABLE `painel_grupo_local` ENABLE KEYS */;
