# MD-dispositivo_tipo-colunas — Colunas

## Tabela: `dispositivo_tipo`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_dispositivo_tipo` | bigint | NOT NULL AUTO_INCREMENT |
| `nome` | varchar(50) | CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL |
| `descricao` | varchar(200) | CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL |
| `permite_login_usuario` | tinyint(1) | DEFAULT '1' |
| `requer_autenticacao` | tinyint(1) | DEFAULT '1' |
| `usa_tts` | tinyint(1) | DEFAULT '0' |
| `exibe_painel` | tinyint(1) | DEFAULT '0' |
| `criado_em` | datetime(6) | DEFAULT CURRENT_TIMESTAMP(6) |
| `id_entidade` | bigint | unsigned DEFAULT NULL |

---

## Índices

PRIMARY KEY (`id_dispositivo_tipo`)
/*!40000 ALTER TABLE `dispositivo_tipo` DISABLE KEYS */;
/*!40000 ALTER TABLE `dispositivo_tipo` ENABLE KEYS */;
