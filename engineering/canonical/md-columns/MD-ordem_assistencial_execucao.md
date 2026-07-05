# MD-ordem_assistencial_execucao-colunas — Colunas

## Tabela: `ordem_assistencial_execucao`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_execucao` | bigint | NOT NULL AUTO_INCREMENT |
| `id_item` | bigint | NOT NULL |
| `id_aprazamento` | bigint | DEFAULT NULL |
| `acao` | enum('REALIZADO','NAO_REALIZADO','ESTORNADO') | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL |
| `quantidade` | decimal(10,2) | DEFAULT NULL |
| `realizado_em` | datetime | NOT NULL DEFAULT CURRENT_TIMESTAMP |
| `id_usuario` | bigint | NOT NULL |
| `id_sessao_usuario` | bigint | NOT NULL |
| `id_local_operacional` | bigint | DEFAULT NULL |
| `observacao` | text | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci |
| `payload` | json | DEFAULT NULL |
| `id_atendimento` | bigint | unsigned NOT NULL |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_execucao`),
KEY `idx_exec_item_data` (`id_item`,`realizado_em`),
KEY `idx_exec_apraz` (`id_aprazamento`),
KEY `fk_ordem_assistencial_execucao_atendimento` (`id_atendimento`),
KEY `idx_oasse_ent` (`id_entidade`),
CONSTRAINT `fk_exec_apraz` FOREIGN KEY (`id_aprazamento`) REFERENCES `ordem_assistencial_aprazamento` (`id_aprazamento`),
CONSTRAINT `fk_exec_item` FOREIGN KEY (`id_item`) REFERENCES `ordem_assistencial_item` (`id_item`),
CONSTRAINT `fk_ordem_assistencial_execucao_atendimento` FOREIGN KEY (`id_atendimento`) REFERENCES `atendimento` (`id_atendimento`) ON DELETE CASCADE ON UPDATE CASCADE,
CONSTRAINT `fk_ordem_assistencial_execucao_entidade` FOREIGN KEY (`id_entidade`) REFERENCES `saas_entidade` (`id_entidade`)
/*!40000 ALTER TABLE `ordem_assistencial_execucao` DISABLE KEYS */;
/*!40000 ALTER TABLE `ordem_assistencial_execucao` ENABLE KEYS */;
