# MD-auth_bloqueio-colunas — Colunas

## Tabela: `auth_bloqueio`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_bloqueio` | bigint | NOT NULL AUTO_INCREMENT |
| `id_usuario` | bigint | NOT NULL |
| `tipo_bloqueio` | enum('SENHA_EXPIRADA','TENTATIVAS_EXCEDIDAS','ADMINISTRATIVO','INATIVIDADE','FRAUDE') | CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL |
| `motivo` | text | CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL |
| `bloqueado_por` | bigint | DEFAULT NULL |
| `expira_em` | datetime | DEFAULT NULL |
| `ativo` | tinyint(1) | DEFAULT '1' |
| `desbloqueado_por` | bigint | DEFAULT NULL |
| `desbloqueado_em` | datetime | DEFAULT NULL |
| `criado_em` | datetime | DEFAULT CURRENT_TIMESTAMP |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_bloqueio`),
KEY `idx_bloqueio_usuario` (`id_usuario`),
KEY `idx_bloqueio_expira` (`expira_em`),
CONSTRAINT `fk_bloqueio_usuario` FOREIGN KEY (`id_usuario`) REFERENCES `usuario` (`id_usuario`) ON DELETE CASCADE
/*!40000 ALTER TABLE `auth_bloqueio` DISABLE KEYS */;
/*!40000 ALTER TABLE `auth_bloqueio` ENABLE KEYS */;
