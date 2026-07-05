# MD-runtime_execution_queue-colunas — Colunas

## Tabela: `runtime_execution_queue`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id` | varchar(36) | CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL |
| `id_sessao` | bigint | NOT NULL |
| `id_usuario` | bigint | NOT NULL |
| `id_perfil` | bigint | NOT NULL |
| `acao` | varchar(100) | CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL |
| `contexto` | varchar(60) | CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT 'DEFAULT' |
| `payload` | json | DEFAULT NULL |
| `status` | enum('PENDENTE','PROCESSANDO','CONCLUIDO','ERRO','CANCELADO') | CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT 'PENDENTE' |
| `prioridade` | int | DEFAULT '0' |
| `retry_count` | int | DEFAULT '0' |
| `ultimo_erro` | text | CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci |
| `duracao_ms` | int | DEFAULT NULL |
| `resultado` | text | CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci |
| `criado_em` | datetime | DEFAULT CURRENT_TIMESTAMP |
| `atualizado_em` | datetime | DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id`),
KEY `idx_status` (`status`,`criado_em`),
KEY `idx_usuario` (`id_usuario`),
KEY `idx_sessao` (`id_sessao`)
/*!40000 ALTER TABLE `runtime_execution_queue` DISABLE KEYS */;
/*!40000 ALTER TABLE `runtime_execution_queue` ENABLE KEYS */;
