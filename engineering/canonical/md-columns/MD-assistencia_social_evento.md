# MD-assistencia_social_evento-colunas — Colunas

## Tabela: `assistencia_social_evento`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_evento` | bigint | NOT NULL AUTO_INCREMENT |
| `id_as` | bigint | NOT NULL |
| `id_sessao_usuario` | bigint | NOT NULL |
| `tipo` | varchar(50) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL |
| `detalhe` | text | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci |
| `id_usuario` | bigint | NOT NULL |
| `criado_em` | datetime | NOT NULL DEFAULT CURRENT_TIMESTAMP |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_evento`),
KEY `idx_as_evento_as` (`id_as`,`criado_em`),
KEY `idx_as_evento_sessao` (`id_sessao_usuario`,`criado_em`),
KEY `idx_as_evento_usuario` (`id_usuario`,`criado_em`),
CONSTRAINT `fk_as_evento_as` FOREIGN KEY (`id_as`) REFERENCES `assistencia_social_atendimento` (`id_as`),
CONSTRAINT `fk_as_evento_sessao` FOREIGN KEY (`id_sessao_usuario`) REFERENCES `sessao_usuario` (`id_sessao_usuario`),
CONSTRAINT `fk_as_evento_usuario` FOREIGN KEY (`id_usuario`) REFERENCES `usuario` (`id_usuario`)
/*!40000 ALTER TABLE `assistencia_social_evento` DISABLE KEYS */;
/*!40000 ALTER TABLE `assistencia_social_evento` ENABLE KEYS */;
