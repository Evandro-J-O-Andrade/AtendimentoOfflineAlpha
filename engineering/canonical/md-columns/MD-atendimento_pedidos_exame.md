# MD-atendimento_pedidos_exame-colunas — Colunas

## Tabela: `atendimento_pedidos_exame`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id` | bigint | NOT NULL AUTO_INCREMENT |
| `id_atendimento` | bigint | unsigned NOT NULL |
| `id_medico_solicitante` | bigint | NOT NULL |
| `id_exame_tuss` | varchar(20) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL |
| `status_exame` | enum('SOLICITADO','COLETADO','EM_ANALISE','LAUDADO','ENTREGUE') | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT 'SOLICITADO' |
| `prioridade` | enum('ELETIVO','URGENTE','EMERGENCIA') | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT 'ELETIVO' |
| `data_solicitacao` | datetime | DEFAULT CURRENT_TIMESTAMP |
| `url_laudo_pacs` | varchar(255) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id`),
KEY `fk_pedido_tuss` (`id_exame_tuss`),
KEY `fk_atendimento_pedidos_exame_atendimento` (`id_atendimento`),
KEY `idx_apex_ent` (`id_entidade`),
CONSTRAINT `fk_atendimento_pedidos_exame_atendimento` FOREIGN KEY (`id_atendimento`) REFERENCES `atendimento` (`id_atendimento`) ON DELETE CASCADE ON UPDATE CASCADE,
CONSTRAINT `fk_atendimento_pedidos_exame_entidade` FOREIGN KEY (`id_entidade`) REFERENCES `saas_entidade` (`id_entidade`),
CONSTRAINT `fk_pedido_tuss` FOREIGN KEY (`id_exame_tuss`) REFERENCES `tabela_tuss` (`codigo_tuss`)
/*!40000 ALTER TABLE `atendimento_pedidos_exame` DISABLE KEYS */;
/*!40000 ALTER TABLE `atendimento_pedidos_exame` ENABLE KEYS */;
