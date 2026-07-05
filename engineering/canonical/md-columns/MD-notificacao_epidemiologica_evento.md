# MD-notificacao_epidemiologica_evento-colunas — Colunas

## Tabela: `notificacao_epidemiologica_evento`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_evento` | bigint | NOT NULL AUTO_INCREMENT |
| `id_notificacao` | bigint | NOT NULL |
| `id_sessao_usuario` | bigint | NOT NULL |
| `tipo` | varchar(50) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL |
| `detalhe` | text | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci |
| `id_usuario` | bigint | NOT NULL |
| `criado_em` | datetime | NOT NULL DEFAULT CURRENT_TIMESTAMP |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_evento`),
KEY `idx_ne_evento_notif` (`id_notificacao`,`criado_em`),
KEY `idx_ne_evento_sessao` (`id_sessao_usuario`,`criado_em`),
KEY `idx_ne_evento_usuario` (`id_usuario`,`criado_em`),
CONSTRAINT `fk_ne_evento_notif` FOREIGN KEY (`id_notificacao`) REFERENCES `notificacao_epidemiologica` (`id`),
CONSTRAINT `fk_ne_evento_usuario` FOREIGN KEY (`id_usuario`) REFERENCES `usuario` (`id_usuario`)
/*!40000 ALTER TABLE `notificacao_epidemiologica_evento` DISABLE KEYS */;
/*!40000 ALTER TABLE `notificacao_epidemiologica_evento` ENABLE KEYS */;
