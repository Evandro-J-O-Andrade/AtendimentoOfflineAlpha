# MD-auditoria_contexto-colunas — Colunas

## Tabela: `auditoria_contexto`

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
| `acao` | varchar(60) | NOT NULL |
| `detalhes` | json | DEFAULT NULL |
| `criado_em` | datetime(6) | NOT NULL DEFAULT CURRENT_TIMESTAMP(6) |

---

## Índices

PRIMARY KEY (`id`),
KEY `idx_sessao` (`id_sessao_usuario`),
KEY `idx_usuario_criado` (`id_usuario`,`criado_em`),
KEY `idx_entidade_unidade` (`id_entidade`,`id_unidade`),
KEY `idx_atendimento` (`id_atendimento`),
KEY `idx_local` (`id_local`),
KEY `fk_aud_ctx_unidade` (`id_unidade`),
CONSTRAINT `fk_aud_ctx_atend` FOREIGN KEY (`id_atendimento`) REFERENCES `atendimento` (`id_atendimento`) ON DELETE SET NULL,
CONSTRAINT `fk_aud_ctx_local` FOREIGN KEY (`id_local`) REFERENCES `local` (`id_local`) ON DELETE RESTRICT,
CONSTRAINT `fk_aud_ctx_sessao` FOREIGN KEY (`id_sessao_usuario`) REFERENCES `sessao_usuario` (`id_sessao_usuario`) ON DELETE CASCADE,
CONSTRAINT `fk_aud_ctx_unidade` FOREIGN KEY (`id_unidade`) REFERENCES `unidade` (`id_unidade`) ON DELETE RESTRICT,
CONSTRAINT `fk_aud_ctx_usuario` FOREIGN KEY (`id_usuario`) REFERENCES `usuario` (`id_usuario`) ON DELETE CASCADE,
CONSTRAINT `fk_auditoria_contexto_entidade` FOREIGN KEY (`id_entidade`) REFERENCES `saas_entidade` (`id_entidade`),
/*!40000 ALTER TABLE `auditoria_contexto` DISABLE KEYS */;
/*!40000 ALTER TABLE `auditoria_contexto` ENABLE KEYS */;
