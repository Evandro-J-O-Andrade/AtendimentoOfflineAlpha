# MD-notificacao_epidemiologica-colunas — Colunas

## Tabela: `notificacao_epidemiologica`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id` | bigint | NOT NULL AUTO_INCREMENT |
| `id_atendimento` | bigint | NOT NULL |
| `cid_10` | varchar(10) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL |
| `doenca_suspeita` | varchar(100) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL |
| `status_notificacao` | enum('PENDENTE','ENVIADO_MS','ARQUIVADO') | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT 'PENDENTE' |
| `data_evento` | datetime | DEFAULT CURRENT_TIMESTAMP |
| `id_sessao_usuario` | bigint | DEFAULT NULL |
| `id_usuario_criador` | bigint | DEFAULT NULL |
| `observacao` | text | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci |
| `protocolo_ms` | varchar(50) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL |
| `atualizado_em` | datetime | DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id`),
KEY `idx_notif_epid_sessao` (`id_sessao_usuario`),
KEY `idx_notif_epid_usuario` (`id_usuario_criador`)
/*!40000 ALTER TABLE `notificacao_epidemiologica` DISABLE KEYS */;
/*!40000 ALTER TABLE `notificacao_epidemiologica` ENABLE KEYS */;
