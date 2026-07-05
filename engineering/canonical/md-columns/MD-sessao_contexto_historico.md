# MD-sessao_contexto_historico-colunas — Colunas

## Tabela: `sessao_contexto_historico`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id` | bigint | unsigned NOT NULL AUTO_INCREMENT |
| `id_sessao_usuario` | bigint | NOT NULL |
| `id_usuario` | bigint | NOT NULL |
| `id_atendimento` | bigint | unsigned DEFAULT NULL |
| `id_entidade` | bigint | unsigned NOT NULL |
| `id_unidade` | bigint | unsigned NOT NULL |
| `id_local` | bigint | NOT NULL |
| `contexto_anterior` | json | DEFAULT NULL |
| `contexto_novo` | json | DEFAULT NULL |
| `criado_em` | datetime(6) | NOT NULL DEFAULT CURRENT_TIMESTAMP(6) |

---

## Índices

PRIMARY KEY (`id`),
KEY `idx_hist_sessao` (`id_sessao_usuario`,`criado_em`),
KEY `idx_hist_usuario` (`id_usuario`,`criado_em`),
KEY `idx_hist_ent_unid` (`id_entidade`,`id_unidade`,`criado_em`),
KEY `idx_hist_atendimento` (`id_atendimento`),
KEY `idx_hist_local` (`id_local`),
KEY `fk_hist_ctx_unidade` (`id_unidade`),
CONSTRAINT `fk_hist_ctx_atend` FOREIGN KEY (`id_atendimento`) REFERENCES `atendimento` (`id_atendimento`) ON DELETE SET NULL,
CONSTRAINT `fk_hist_ctx_local` FOREIGN KEY (`id_local`) REFERENCES `local` (`id_local`) ON DELETE RESTRICT,
CONSTRAINT `fk_hist_ctx_sessao` FOREIGN KEY (`id_sessao_usuario`) REFERENCES `sessao_usuario` (`id_sessao_usuario`) ON DELETE CASCADE,
CONSTRAINT `fk_hist_ctx_unidade` FOREIGN KEY (`id_unidade`) REFERENCES `unidade` (`id_unidade`) ON DELETE RESTRICT,
CONSTRAINT `fk_hist_ctx_usuario` FOREIGN KEY (`id_usuario`) REFERENCES `usuario` (`id_usuario`) ON DELETE CASCADE,
CONSTRAINT `fk_sessao_contexto_historico_entidade` FOREIGN KEY (`id_entidade`) REFERENCES `saas_entidade` (`id_entidade`),
/*!40000 ALTER TABLE `sessao_contexto_historico` DISABLE KEYS */;
/*!40000 ALTER TABLE `sessao_contexto_historico` ENABLE KEYS */;
