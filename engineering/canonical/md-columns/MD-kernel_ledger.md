# MD-kernel_ledger-colunas — Colunas

## Tabela: `kernel_ledger`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_transacao` | varchar(36) | CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL |
| `id_sessao` | bigint | DEFAULT NULL |
| `id_usuario` | bigint | NOT NULL |
| `id_perfil` | bigint | NOT NULL |
| `acao` | varchar(100) | CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL |
| `contexto` | varchar(60) | CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT 'DEFAULT' |
| `payload` | json | DEFAULT NULL |
| `status` | varchar(20) | CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL |
| `duracao_ms` | int | DEFAULT NULL |
| `mensagem` | text | CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci |
| `id_tenant` | bigint | DEFAULT '1' |
| `registrado_em` | datetime | DEFAULT CURRENT_TIMESTAMP |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_transacao`),
KEY `idx_usuario` (`id_usuario`,`registrado_em`),
KEY `idx_acao` (`acao`,`registrado_em`),
KEY `idx_contexto` (`contexto`,`registrado_em`),
KEY `idx_status` (`status`,`registrado_em`),
KEY `idx_tenant` (`id_tenant`,`registrado_em`)
/*!40000 ALTER TABLE `kernel_ledger` DISABLE KEYS */;
/*!40000 ALTER TABLE `kernel_ledger` ENABLE KEYS */;
