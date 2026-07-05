# MD-usuario_sistema_acl_evento-colunas — Colunas

## Tabela: `usuario_sistema_acl_evento`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_acl_evento` | bigint | NOT NULL AUTO_INCREMENT |
| `id_usuario` | bigint | NOT NULL |
| `id_sistema` | bigint | NOT NULL |
| `id_perfil` | bigint | NOT NULL |
| `evento` | varchar(50) | NOT NULL |
| `origem_dispositivo` | varchar(100) | DEFAULT NULL |
| `origem_ip` | varchar(50) | DEFAULT NULL |
| `criado_em` | datetime(6) | DEFAULT CURRENT_TIMESTAMP(6) |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_acl_evento`),
KEY `idx_acl_usuario` (`id_usuario`),
KEY `idx_acl_evento_data` (`criado_em`)
/*!40000 ALTER TABLE `usuario_sistema_acl_evento` DISABLE KEYS */;
/*!40000 ALTER TABLE `usuario_sistema_acl_evento` ENABLE KEYS */;
