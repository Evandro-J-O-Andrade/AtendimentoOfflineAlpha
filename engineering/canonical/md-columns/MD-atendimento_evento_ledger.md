# MD-atendimento_evento_ledger-colunas — Colunas

## Tabela: `atendimento_evento_ledger`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_evento` | bigint | NOT NULL AUTO_INCREMENT |
| `uuid_transacao` | char(36) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL |
| `uuid_transacao_pai` | char(36) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL |
| `sequencia_evento` | int | NOT NULL |
| `id_usuario` | bigint | NOT NULL |
| `id_sessao` | bigint | NOT NULL |
| `id_perfil` | bigint | NOT NULL |
| `nome_usuario` | varchar(100) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL |
| `acao` | varchar(100) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL |
| `modulo` | varchar(50) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL |
| `sub_modulo` | varchar(50) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL |
| `estado_origem` | varchar(50) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL |
| `estado_destino` | varchar(50) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL |
| `estado_anterior` | json | DEFAULT NULL |
| `estado_novo` | json | DEFAULT NULL |
| `payload_original` | json | DEFAULT NULL |
| `payload_processado` | json | DEFAULT NULL |
| `id_atendimento` | bigint | unsigned NOT NULL |
| `status_evento` | enum('SUCESSO','ERRO','AVISO','CANCELADO','ROLLBACK') | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'SUCESSO' |
| `codigo_erro` | varchar(50) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL |
| `mensagem` | varchar(1000) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL |
| `ip_origem` | varchar(45) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL |
| `user_agent` | varchar(500) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL |
| `hostname` | varchar(100) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL |
| `processing_time_ms` | int | DEFAULT NULL |
| `created_at` | datetime(6) | NOT NULL DEFAULT CURRENT_TIMESTAMP(6) |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_evento`),
UNIQUE KEY `uk_chain_evento` (`uuid_transacao`,`sequencia_evento`),
KEY `idx_chain_pai` (`uuid_transacao_pai`),
KEY `idx_usuario` (`id_usuario`),
KEY `idx_sessao` (`id_sessao`),
KEY `idx_perfil` (`id_perfil`),
KEY `idx_modulo` (`modulo`),
KEY `idx_acao` (`acao`),
KEY `idx_created` (`created_at`),
KEY `idx_atendimento` (`id_atendimento`),
KEY `idx_status` (`status_evento`),
KEY `idx_aevtled_ent` (`id_entidade`),
CONSTRAINT `fk_atendimento_evento_ledger_atendimento` FOREIGN KEY (`id_atendimento`) REFERENCES `atendimento` (`id_atendimento`) ON DELETE CASCADE ON UPDATE CASCADE,
CONSTRAINT `fk_atendimento_evento_ledger_entidade` FOREIGN KEY (`id_entidade`) REFERENCES `saas_entidade` (`id_entidade`)
/*!40000 ALTER TABLE `atendimento_evento_ledger` DISABLE KEYS */;
/*!40000 ALTER TABLE `atendimento_evento_ledger` ENABLE KEYS */;
