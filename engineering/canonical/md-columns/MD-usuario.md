# MD-usuario-colunas — Colunas

## Tabela: `usuario`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_usuario` | bigint | NOT NULL AUTO_INCREMENT |
| `id_pessoa` | bigint | DEFAULT NULL |
| `id_entidade` | bigint | unsigned NOT NULL |
| `login` | varchar(80) | NOT NULL |
| `senha_hash` | varchar(255) | NOT NULL |
| `tentativas_login` | int | DEFAULT '0' |
| `bloqueado_ate` | datetime(6) | DEFAULT NULL |
| `ultimo_login` | datetime(6) | DEFAULT NULL |
| `ultimo_ip` | varchar(45) | DEFAULT NULL |
| `criado_em` | datetime(6) | DEFAULT CURRENT_TIMESTAMP(6) |
| `atualizado_em` | datetime(6) | DEFAULT NULL |

---

## Índices

PRIMARY KEY (`id_usuario`),
UNIQUE KEY `login` (`login`),
UNIQUE KEY `id_usuario` (`id_usuario`,`id_entidade`),
UNIQUE KEY `id_usuario_2` (`id_usuario`,`id_entidade`),
KEY `idx_usuario_login` (`login`),
KEY `fk_usuario_entidade` (`id_entidade`),
CONSTRAINT `fk_usuario_entidade` FOREIGN KEY (`id_entidade`) REFERENCES `saas_entidade` (`id_entidade`)
/*!40000 ALTER TABLE `usuario` DISABLE KEYS */;
/*!40000 ALTER TABLE `usuario` ENABLE KEYS */;
