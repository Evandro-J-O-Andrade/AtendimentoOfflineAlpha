# MD-ordem_assistencial_aprazamento-colunas — Colunas

## Tabela: `ordem_assistencial_aprazamento`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_aprazamento` | bigint | NOT NULL AUTO_INCREMENT |
| `id_item` | bigint | NOT NULL |
| `previsto_em` | datetime | NOT NULL |
| `status` | enum('PENDENTE','REALIZADO','NAO_REALIZADO','ESTORNADO','SUSPENSO','CANCELADO') | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'PENDENTE' |
| `executado_em` | datetime | DEFAULT NULL |
| `id_usuario_execucao` | bigint | DEFAULT NULL |
| `id_sessao_usuario_execucao` | bigint | DEFAULT NULL |
| `id_local_operacional_execucao` | bigint | DEFAULT NULL |
| `observacao` | text | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci |
| `criado_em` | datetime | NOT NULL DEFAULT CURRENT_TIMESTAMP |
| `criado_por` | bigint | DEFAULT NULL |
| `id_sessao_usuario_criado` | bigint | DEFAULT NULL |
| `id_atendimento` | bigint | unsigned NOT NULL |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_aprazamento`),
UNIQUE KEY `uk_apraz_item_previsto` (`id_item`,`previsto_em`),
KEY `idx_apraz_status_previsto` (`status`,`previsto_em`),
KEY `fk_apraz_exec_user` (`id_usuario_execucao`),
KEY `fk_apraz_exec_sessao` (`id_sessao_usuario_execucao`),
KEY `fk_apraz_exec_local` (`id_local_operacional_execucao`),
KEY `fk_ordem_assistencial_aprazamento_atendimento` (`id_atendimento`),
KEY `idx_oassa_ent` (`id_entidade`),
CONSTRAINT `fk_apraz_exec_local` FOREIGN KEY (`id_local_operacional_execucao`) REFERENCES `local_operacional` (`id_local_operacional`),
CONSTRAINT `fk_apraz_exec_user` FOREIGN KEY (`id_usuario_execucao`) REFERENCES `usuario` (`id_usuario`),
CONSTRAINT `fk_apraz_item` FOREIGN KEY (`id_item`) REFERENCES `ordem_assistencial_item` (`id_item`),
CONSTRAINT `fk_ordem_assistencial_aprazamento_atendimento` FOREIGN KEY (`id_atendimento`) REFERENCES `atendimento` (`id_atendimento`) ON DELETE CASCADE ON UPDATE CASCADE,
CONSTRAINT `fk_ordem_assistencial_aprazamento_entidade` FOREIGN KEY (`id_entidade`) REFERENCES `saas_entidade` (`id_entidade`)
/*!40000 ALTER TABLE `ordem_assistencial_aprazamento` DISABLE KEYS */;
/*!40000 ALTER TABLE `ordem_assistencial_aprazamento` ENABLE KEYS */;
