# MD-sessao_usuario-colunas — Colunas

## Tabela: `sessao_usuario`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_sessao_usuario` | bigint | NOT NULL AUTO_INCREMENT |
| `uuid_sessao` | char(36) | NOT NULL |
| `id_usuario` | bigint | NOT NULL |
| `id_perfil` | bigint | DEFAULT NULL |
| `id_sistema` | bigint | NOT NULL |
| `id_unidade` | bigint | unsigned NOT NULL |
| `id_local` | bigint | DEFAULT NULL |
| `id_sala` | bigint | DEFAULT NULL |
| `id_dispositivo` | bigint | DEFAULT NULL |
| `token_jwt` | varchar(512) | NOT NULL |
| `refresh_token` | varchar(512) | DEFAULT NULL |
| `ip_origem` | varchar(45) | DEFAULT NULL |
| `user_agent` | varchar(255) | DEFAULT NULL |
| `iniciado_em` | datetime(6) | NOT NULL |
| `expira_em` | datetime(6) | NOT NULL |
| `contexto_definido_em` | datetime(6) | DEFAULT NULL |
| `finalizado_em` | datetime(6) | DEFAULT NULL |
| `motivo_finalizacao` | varchar(120) | DEFAULT NULL |
| `ativo` | tinyint(1) | DEFAULT '1' |
| `revogado` | tinyint(1) | DEFAULT '0' |
| `criado_em` | datetime(6) | DEFAULT CURRENT_TIMESTAMP(6) |
| `atualizado_em` | datetime(6) | DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP(6) |
| `ip_country` | varchar(80) | DEFAULT NULL |
| `ip_city` | varchar(120) | DEFAULT NULL |
| `token_hash` | varchar(128) | DEFAULT NULL |
| `refresh_hash` | varchar(128) | DEFAULT NULL |
| `device_fingerprint` | varchar(255) | DEFAULT NULL |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_sessao_usuario`),
UNIQUE KEY `uk_sessao_uuid` (`uuid_sessao`),
KEY `idx_sessao_usuario` (`id_usuario`),
KEY `idx_sessao_perfil` (`id_perfil`),
KEY `idx_sessao_sistema` (`id_sistema`),
KEY `idx_sessao_unidade` (`id_unidade`),
KEY `idx_sessao_token` (`token_jwt`(255)),
KEY `idx_sessao_refresh` (`refresh_token`(255)),
KEY `idx_sessao_expira` (`expira_em`),
KEY `idx_sessao_ativo` (`ativo`),
KEY `idx_sessao_local` (`id_local`),
KEY `idx_sessao_sala` (`id_sala`),
KEY `idx_sessao_user_ent` (`id_usuario`,`id_entidade`),
KEY `fk_sessao_usuario_entidade` (`id_entidade`),
CONSTRAINT `fk_sessao_usuario_entidade` FOREIGN KEY (`id_entidade`) REFERENCES `saas_entidade` (`id_entidade`),
CONSTRAINT `fk_sessao_usuario_local` FOREIGN KEY (`id_local`) REFERENCES `local` (`id_local`),
CONSTRAINT `fk_sessao_usuario_perfil` FOREIGN KEY (`id_perfil`) REFERENCES `perfil` (`id_perfil`),
CONSTRAINT `fk_sessao_usuario_sistema` FOREIGN KEY (`id_sistema`) REFERENCES `sistema` (`id_sistema`),
CONSTRAINT `fk_sessao_usuario_unidade` FOREIGN KEY (`id_unidade`) REFERENCES `unidade` (`id_unidade`),
CONSTRAINT `fk_sessao_usuario_usuario` FOREIGN KEY (`id_usuario`) REFERENCES `usuario` (`id_usuario`)
/*!40000 ALTER TABLE `sessao_usuario` DISABLE KEYS */;
/*!40000 ALTER TABLE `sessao_usuario` ENABLE KEYS */;
