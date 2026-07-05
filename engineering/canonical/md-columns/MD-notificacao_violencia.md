# MD-notificacao_violencia-colunas — Colunas

## Tabela: `notificacao_violencia`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id` | bigint | NOT NULL AUTO_INCREMENT |
| `id_atendimento` | bigint | unsigned NOT NULL |
| `categoria` | enum('VIOLENCIA','AGRESSAO','ABUSO','TRANSITO','OUTRA') | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL |
| `tipo` | varchar(80) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL |
| `data_ocorrencia` | datetime | DEFAULT NULL |
| `local_ocorrencia` | varchar(120) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL |
| `suspeito_relacao` | varchar(120) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL |
| `cid10_relacionado` | varchar(10) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL |
| `status_notificacao` | enum('ABERTA','EM_INVESTIGACAO','ENVIADA','ARQUIVADA') | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'ABERTA' |
| `id_sessao_usuario` | bigint | NOT NULL |
| `id_usuario_criador` | bigint | NOT NULL |
| `observacao` | text | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci |
| `protocolo_externo` | varchar(60) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL |
| `criado_em` | datetime | NOT NULL DEFAULT CURRENT_TIMESTAMP |
| `atualizado_em` | datetime | NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id`),
KEY `idx_nv_atendimento` (`id_atendimento`),
KEY `idx_nv_status` (`status_notificacao`),
KEY `idx_nv_sessao` (`id_sessao_usuario`)
/*!40000 ALTER TABLE `notificacao_violencia` DISABLE KEYS */;
/*!40000 ALTER TABLE `notificacao_violencia` ENABLE KEYS */;
