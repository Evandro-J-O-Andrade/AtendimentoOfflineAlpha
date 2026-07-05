# MD-gaso_evento-colunas — Colunas

## Tabela: `gaso_evento`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_gaso_evento` | bigint | NOT NULL AUTO_INCREMENT |
| `id_gaso` | bigint | NOT NULL |
| `evento` | varchar(80) | NOT NULL |
| `id_usuario` | bigint | DEFAULT NULL |
| `id_sessao_usuario` | bigint | DEFAULT NULL |
| `criado_em` | datetime | DEFAULT CURRENT_TIMESTAMP |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_gaso_evento`),
KEY `idx_ge_gaso` (`id_gaso`),
KEY `fk_ge_user` (`id_usuario`),
KEY `idx_ge_sessao` (`id_sessao_usuario`),
CONSTRAINT `fk_ge_gaso` FOREIGN KEY (`id_gaso`) REFERENCES `gaso_solicitacao` (`id_gaso`),
CONSTRAINT `fk_ge_user` FOREIGN KEY (`id_usuario`) REFERENCES `usuario` (`id_usuario`)
/*!40000 ALTER TABLE `gaso_evento` DISABLE KEYS */;
/*!40000 ALTER TABLE `gaso_evento` ENABLE KEYS */;
