# MD-usuario_historico_senha-colunas — Colunas

## Tabela: `usuario_historico_senha`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_historico` | bigint | NOT NULL AUTO_INCREMENT |
| `id_usuario` | bigint | NOT NULL |
| `senha_hash` | varchar(255) | CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL |
| `criado_em` | datetime | DEFAULT CURRENT_TIMESTAMP |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_historico`),
KEY `fk_hist_senha_usuario` (`id_usuario`),
CONSTRAINT `fk_hist_senha_usuario` FOREIGN KEY (`id_usuario`) REFERENCES `usuario` (`id_usuario`)
/*!40000 ALTER TABLE `usuario_historico_senha` DISABLE KEYS */;
/*!40000 ALTER TABLE `usuario_historico_senha` ENABLE KEYS */;
