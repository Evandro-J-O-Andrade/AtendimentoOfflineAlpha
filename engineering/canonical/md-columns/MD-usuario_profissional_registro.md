# MD-usuario_profissional_registro-colunas — Colunas

## Tabela: `usuario_profissional_registro`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_usuario` | bigint | NOT NULL |
| `conselho` | varchar(20) | CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL |
| `numero_registro` | varchar(30) | CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL |
| `uf_registro` | char(2) | CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL |
| `especialidade_principal` | varchar(100) | CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_usuario`),
CONSTRAINT `fk_prof_usuario` FOREIGN KEY (`id_usuario`) REFERENCES `usuarios` (`id`)
/*!40000 ALTER TABLE `usuario_profissional_registro` DISABLE KEYS */;
/*!40000 ALTER TABLE `usuario_profissional_registro` ENABLE KEYS */;
