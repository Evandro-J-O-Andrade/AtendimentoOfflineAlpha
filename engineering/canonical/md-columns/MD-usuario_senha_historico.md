# MD-usuario_senha_historico-colunas — Colunas

## Tabela: `usuario_senha_historico`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_usuario_senha_hist` | bigint | NOT NULL AUTO_INCREMENT |
| `id_usuario` | bigint | NOT NULL |
| `hash_formato` | varchar(255) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL |
| `motivo` | enum('CRIACAO','TROCA','RESET_TI','RESET_ADMIN','MIGRACAO') | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL |
| `detalhe` | varchar(4000) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL |
| `criado_em` | datetime | NOT NULL DEFAULT CURRENT_TIMESTAMP |
| `id_sessao_usuario` | bigint | DEFAULT NULL |
| `id_usuario_executor` | bigint | DEFAULT NULL |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_usuario_senha_hist`),
KEY `idx_ush_usuario_data` (`id_usuario`,`criado_em`),
KEY `idx_ush_motivo` (`motivo`,`criado_em`),
KEY `fk_ush_sessao` (`id_sessao_usuario`),
KEY `fk_ush_executor` (`id_usuario_executor`),
CONSTRAINT `fk_ush_executor` FOREIGN KEY (`id_usuario_executor`) REFERENCES `usuario` (`id_usuario`),
CONSTRAINT `fk_ush_usuario` FOREIGN KEY (`id_usuario`) REFERENCES `usuario` (`id_usuario`)
/*!40000 ALTER TABLE `usuario_senha_historico` DISABLE KEYS */;
/*!40000 ALTER TABLE `usuario_senha_historico` ENABLE KEYS */;
