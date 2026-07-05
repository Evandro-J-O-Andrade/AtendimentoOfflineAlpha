# MD-runtime_lock_semantico-colunas — Colunas

## Tabela: `runtime_lock_semantico`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_lock` | bigint | NOT NULL AUTO_INCREMENT |
| `dominio_fluxo` | varchar(50) | NOT NULL |
| `id_recurso` | varchar(100) | NOT NULL |
| `id_sessao_usuario` | bigint | NOT NULL |
| `token_lock` | char(36) | NOT NULL |
| `expiracao_lock` | datetime(6) | NOT NULL |
| `criado_em` | datetime(6) | DEFAULT CURRENT_TIMESTAMP(6) |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_lock`),
UNIQUE KEY `uk_lock_recurso` (`dominio_fluxo`,`id_recurso`),
KEY `idx_lock_expiracao` (`expiracao_lock`)
/*!40000 ALTER TABLE `runtime_lock_semantico` DISABLE KEYS */;
/*!40000 ALTER TABLE `runtime_lock_semantico` ENABLE KEYS */;
