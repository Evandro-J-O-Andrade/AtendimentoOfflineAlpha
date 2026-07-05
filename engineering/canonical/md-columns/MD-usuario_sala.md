# MD-usuario_sala-colunas — Colunas

## Tabela: `usuario_sala`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_usuario_sala` | bigint | NOT NULL AUTO_INCREMENT |
| `id_usuario` | bigint | NOT NULL |
| `id_sala` | bigint | unsigned NOT NULL |
| `ativo` | tinyint(1) | DEFAULT '1' |
| `criado_em` | datetime | DEFAULT CURRENT_TIMESTAMP |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_usuario_sala`),
UNIQUE KEY `uk_usuario_sala` (`id_usuario`,`id_sala`),
KEY `idx_usuario` (`id_usuario`),
KEY `idx_sala` (`id_sala`),
KEY `fk_usuario_sala_entidade` (`id_entidade`),
CONSTRAINT `fk_usuario_sala_entidade` FOREIGN KEY (`id_entidade`) REFERENCES `saas_entidade` (`id_entidade`),
CONSTRAINT `fk_usuario_sala_sala` FOREIGN KEY (`id_sala`) REFERENCES `sala` (`id_sala`),
CONSTRAINT `fk_usuario_sala_usuario` FOREIGN KEY (`id_usuario`) REFERENCES `usuario` (`id_usuario`)
/*!40000 ALTER TABLE `usuario_sala` DISABLE KEYS */;
/*!40000 ALTER TABLE `usuario_sala` ENABLE KEYS */;
