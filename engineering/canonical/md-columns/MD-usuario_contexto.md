# MD-usuario_contexto-colunas — Colunas

## Tabela: `usuario_contexto`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_usuario_contexto` | bigint | NOT NULL AUTO_INCREMENT |
| `id_usuario` | bigint | NOT NULL |
| `id_sistema` | bigint | NOT NULL |
| `id_unidade` | bigint | unsigned NOT NULL |
| `id_local_operacional` | bigint | DEFAULT NULL |
| `id_perfil` | bigint | NOT NULL |
| `ativo` | tinyint(1) | DEFAULT '1' |
| `criado_em` | datetime(6) | DEFAULT CURRENT_TIMESTAMP(6) |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_usuario_contexto`),
KEY `idx_usuario_contexto_usuario` (`id_usuario`),
KEY `fk_uc_perfil` (`id_perfil`),
KEY `fk_usuario_contexto_unidade` (`id_unidade`),
KEY `fk_usuario_contexto_entidade` (`id_entidade`),
CONSTRAINT `fk_uc_perfil` FOREIGN KEY (`id_perfil`) REFERENCES `perfil` (`id_perfil`),
CONSTRAINT `fk_uc_usuario` FOREIGN KEY (`id_usuario`) REFERENCES `usuario` (`id_usuario`),
CONSTRAINT `fk_usuario_contexto_entidade` FOREIGN KEY (`id_entidade`) REFERENCES `saas_entidade` (`id_entidade`),
CONSTRAINT `fk_usuario_contexto_unidade` FOREIGN KEY (`id_unidade`) REFERENCES `unidade` (`id_unidade`)
/*!40000 ALTER TABLE `usuario_contexto` DISABLE KEYS */;
/*!40000 ALTER TABLE `usuario_contexto` ENABLE KEYS */;
