# MD-sessao_evento-colunas — Colunas

## Tabela: `sessao_evento`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_evento` | bigint | NOT NULL AUTO_INCREMENT |
| `id_sessao_usuario` | bigint | NOT NULL |
| `id_usuario` | bigint | NOT NULL |
| `tipo_evento` | varchar(60) | NOT NULL |
| `recurso` | varchar(120) | DEFAULT NULL |
| `payload` | json | DEFAULT NULL |
| `ip_origem` | varchar(45) | DEFAULT NULL |
| `criado_em` | datetime(6) | DEFAULT CURRENT_TIMESTAMP(6) |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_evento`),
KEY `idx_evento_sessao` (`id_sessao_usuario`),
KEY `idx_evento_usuario` (`id_usuario`),
KEY `idx_evento_tipo` (`tipo_evento`),
KEY `idx_evento_sessao_data` (`id_sessao_usuario`,`criado_em`),
CONSTRAINT `fk_evento_sessao` FOREIGN KEY (`id_sessao_usuario`) REFERENCES `sessao_usuario` (`id_sessao_usuario`),
CONSTRAINT `fk_evento_usuario` FOREIGN KEY (`id_usuario`) REFERENCES `usuario` (`id_usuario`)
/*!40000 ALTER TABLE `sessao_evento` DISABLE KEYS */;
/*!40000 ALTER TABLE `sessao_evento` ENABLE KEYS */;
