# MD-usuario_perfil-colunas — Colunas

## Tabela: `usuario_perfil`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_usuario` | bigint | NOT NULL |
| `id_entidade` | bigint | unsigned NOT NULL |
| `id_perfil` | bigint | NOT NULL |
| `criado_em` | datetime(6) | DEFAULT CURRENT_TIMESTAMP(6) |

---

## Índices

PRIMARY KEY (`id_usuario`,`id_perfil`),
KEY `idx_up_perfil` (`id_perfil`),
KEY `idx_usuario_perfil_usuario` (`id_usuario`),
KEY `idx_usuario_perfil_perfil` (`id_perfil`),
KEY `idx_usuario_perfil_entidade` (`id_entidade`),
CONSTRAINT `fk_up_perfil` FOREIGN KEY (`id_perfil`) REFERENCES `perfil` (`id_perfil`) ON DELETE CASCADE,
CONSTRAINT `fk_up_usuario` FOREIGN KEY (`id_usuario`) REFERENCES `usuario` (`id_usuario`) ON DELETE CASCADE,
CONSTRAINT `fk_usuario_perfil_entidade` FOREIGN KEY (`id_entidade`) REFERENCES `saas_entidade` (`id_entidade`)
/*!40000 ALTER TABLE `usuario_perfil` DISABLE KEYS */;
/*!40000 ALTER TABLE `usuario_perfil` ENABLE KEYS */;
