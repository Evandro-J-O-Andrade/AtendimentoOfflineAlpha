# MD-perfil_permissao-colunas — Colunas

## Tabela: `perfil_permissao`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_perfil` | bigint | NOT NULL |
| `id_permissao` | bigint | NOT NULL |
| `criado_em` | datetime(6) | DEFAULT CURRENT_TIMESTAMP(6) |
| `id_entidade` | bigint | unsigned DEFAULT NULL |

---

## Índices

PRIMARY KEY (`id_perfil`,`id_permissao`),
KEY `idx_pp_perfil` (`id_perfil`),
KEY `idx_pp_permissao` (`id_permissao`),
KEY `idx_perfil_permissao_perfil` (`id_perfil`),
KEY `idx_perfil_permissao_permissao` (`id_permissao`),
CONSTRAINT `fk_pp_perfil` FOREIGN KEY (`id_perfil`) REFERENCES `perfil` (`id_perfil`) ON DELETE CASCADE,
CONSTRAINT `fk_pp_permissao` FOREIGN KEY (`id_permissao`) REFERENCES `permissao` (`id_permissao`) ON DELETE CASCADE
/*!40000 ALTER TABLE `perfil_permissao` DISABLE KEYS */;
/*!40000 ALTER TABLE `perfil_permissao` ENABLE KEYS */;
