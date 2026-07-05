# MD-login_tentativa-colunas — Colunas

## Tabela: `login_tentativa`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_tentativa` | bigint | NOT NULL AUTO_INCREMENT |
| `id_usuario` | bigint | NOT NULL |
| `login` | varchar(80) | NOT NULL |
| `ip_origem` | varchar(45) | DEFAULT NULL |
| `dispositivo_origem` | varchar(100) | DEFAULT NULL |
| `tentativa_faixa_horaria` | varchar(50) | DEFAULT NULL |
| `sucesso` | tinyint(1) | NOT NULL DEFAULT '0' |
| `metadata` | json | DEFAULT NULL |
| `criado_em` | datetime(6) | NOT NULL DEFAULT CURRENT_TIMESTAMP(6) |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_tentativa`),
KEY `idx_login_tentativa_login` (`login`),
KEY `idx_login_tentativa_ip` (`ip_origem`),
KEY `idx_login_tentativa_usuario` (`id_usuario`),
KEY `idx_login_tentativa_dispositivo` (`dispositivo_origem`),
CONSTRAINT `fk_login_tentativa_usuario` FOREIGN KEY (`id_usuario`) REFERENCES `usuario` (`id_usuario`) ON DELETE CASCADE ON UPDATE CASCADE
/*!40000 ALTER TABLE `login_tentativa` DISABLE KEYS */;
/*!40000 ALTER TABLE `login_tentativa` ENABLE KEYS */;
