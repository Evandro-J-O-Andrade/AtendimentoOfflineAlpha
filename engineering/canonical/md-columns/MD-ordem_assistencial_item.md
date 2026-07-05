# MD-ordem_assistencial_item-colunas — Colunas

## Tabela: `ordem_assistencial_item`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_item` | bigint | NOT NULL AUTO_INCREMENT |
| `id_ordem` | bigint | NOT NULL |
| `tipo_item` | enum('FARMACO','CUIDADO','DIETA','OXIGENIO','PROCEDIMENTO','OUTRO') | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'FARMACO' |
| `id_farmaco` | bigint | DEFAULT NULL |
| `descricao_item` | varchar(255) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL |
| `dose` | varchar(100) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL |
| `via` | varchar(50) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL |
| `posologia` | varchar(100) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL |
| `dias` | int | DEFAULT NULL |
| `quantidade` | decimal(10,2) | DEFAULT NULL |
| `unidade` | varchar(20) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL |
| `frequencia_min` | int | DEFAULT NULL |
| `frequencia_txt` | varchar(50) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL |
| `horarios_json` | json | DEFAULT NULL |
| `inicio_em` | datetime | DEFAULT NULL |
| `fim_em` | datetime | DEFAULT NULL |
| `quantidade_total` | decimal(10,2) | NOT NULL DEFAULT '0.00' |
| `status` | enum('ATIVO','SUSPENSO','ENCERRADO') | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'ATIVO' |
| `observacao` | text | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci |
| `criado_por` | bigint | NOT NULL |
| `id_sessao_usuario_criado` | bigint | DEFAULT NULL |
| `criado_em` | datetime | NOT NULL DEFAULT CURRENT_TIMESTAMP |
| `atualizado_por` | bigint | DEFAULT NULL |
| `id_sessao_usuario_atualizado` | bigint | DEFAULT NULL |
| `atualizado_em` | datetime | DEFAULT NULL |
| `id_atendimento` | bigint | unsigned NOT NULL |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_item`),
KEY `idx_item_ordem` (`id_ordem`),
KEY `idx_item_farmaco` (`id_farmaco`),
KEY `idx_item_tipo_status` (`tipo_item`,`status`),
KEY `idx_item_ordem_status` (`id_ordem`,`status`),
KEY `fk_ordem_assistencial_item_atendimento` (`id_atendimento`),
KEY `idx_oassi_ent` (`id_entidade`),
CONSTRAINT `fk_item_farmaco` FOREIGN KEY (`id_farmaco`) REFERENCES `farmaco` (`id_farmaco`),
CONSTRAINT `fk_item_ordem` FOREIGN KEY (`id_ordem`) REFERENCES `ordem_assistencial` (`id`),
CONSTRAINT `fk_ordem_assistencial_item_atendimento` FOREIGN KEY (`id_atendimento`) REFERENCES `atendimento` (`id_atendimento`) ON DELETE CASCADE ON UPDATE CASCADE,
CONSTRAINT `fk_ordem_assistencial_item_entidade` FOREIGN KEY (`id_entidade`) REFERENCES `saas_entidade` (`id_entidade`)
/*!40000 ALTER TABLE `ordem_assistencial_item` DISABLE KEYS */;
/*!40000 ALTER TABLE `ordem_assistencial_item` ENABLE KEYS */;
