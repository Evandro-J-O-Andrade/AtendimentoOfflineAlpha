# MD-remocao_evento-colunas — Colunas

## Tabela: `remocao_evento`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_remocao_evento` | bigint | NOT NULL AUTO_INCREMENT |
| `id_remocao` | bigint | NOT NULL |
| `evento` | varchar(80) | NOT NULL |
| `id_usuario` | bigint | DEFAULT NULL |
| `criado_em` | datetime | DEFAULT CURRENT_TIMESTAMP |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_remocao_evento`),
KEY `idx_re_remocao` (`id_remocao`),
KEY `fk_re_user` (`id_usuario`),
CONSTRAINT `fk_re_remocao` FOREIGN KEY (`id_remocao`) REFERENCES `remocao` (`id_remocao`),
CONSTRAINT `fk_re_user` FOREIGN KEY (`id_usuario`) REFERENCES `usuario` (`id_usuario`)
/*!40000 ALTER TABLE `remocao_evento` DISABLE KEYS */;
/*!40000 ALTER TABLE `remocao_evento` ENABLE KEYS */;
