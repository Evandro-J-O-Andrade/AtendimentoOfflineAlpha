# MD-guardiao_acl_runtime-colunas — Colunas

## Tabela: `guardiao_acl_runtime`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_guardiao_acl` | bigint | NOT NULL AUTO_INCREMENT |
| `id_usuario` | bigint | NOT NULL |
| `id_sistema` | bigint | NOT NULL |
| `contexto` | varchar(60) | NOT NULL |
| `recurso` | varchar(120) | NOT NULL |
| `criado_em` | datetime(6) | DEFAULT CURRENT_TIMESTAMP(6) |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_guardiao_acl`),
KEY `idx_acl_usuario` (`id_usuario`),
KEY `idx_acl_contexto` (`contexto`),
KEY `idx_acl_recurso` (`recurso`)
/*!40000 ALTER TABLE `guardiao_acl_runtime` DISABLE KEYS */;
/*!40000 ALTER TABLE `guardiao_acl_runtime` ENABLE KEYS */;
