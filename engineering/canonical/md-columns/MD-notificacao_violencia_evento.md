# MD-notificacao_violencia_evento-colunas — Colunas

## Tabela: `notificacao_violencia_evento`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_evento` | bigint | NOT NULL AUTO_INCREMENT |
| `id_notificacao` | bigint | NOT NULL |
| `tipo_evento` | enum('CRIACAO','ALTERACAO','MUDANCA_STATUS','ANEXO','EXPORTACAO','ERRO') | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL |
| `status_anterior` | varchar(30) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL |
| `status_novo` | varchar(30) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL |
| `detalhes` | text | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci |
| `id_sessao_usuario` | bigint | NOT NULL |
| `id_usuario` | bigint | NOT NULL |
| `criado_em` | datetime | NOT NULL DEFAULT CURRENT_TIMESTAMP |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_evento`),
KEY `idx_nve_notif` (`id_notificacao`),
KEY `idx_nve_sessao` (`id_sessao_usuario`),
CONSTRAINT `fk_nve_notif` FOREIGN KEY (`id_notificacao`) REFERENCES `notificacao_violencia` (`id`) ON DELETE CASCADE
/*!40000 ALTER TABLE `notificacao_violencia_evento` DISABLE KEYS */;
/*!40000 ALTER TABLE `notificacao_violencia_evento` ENABLE KEYS */;
