# MD-exame_pedido-colunas — Colunas

## Tabela: `exame_pedido`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_pedido` | bigint | NOT NULL AUTO_INCREMENT |
| `codigo_interno` | varchar(30) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL |
| `id_senha` | bigint | NOT NULL |
| `id_ffa` | bigint | NOT NULL |
| `id_atendimento` | bigint | unsigned NOT NULL |
| `status` | enum('SOLICITADO','COLETADO','EM_LABORATORIO','FINALIZADO','CANCELADO') | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT 'SOLICITADO' |
| `id_usuario_solicitante` | bigint | NOT NULL |
| `criado_em` | datetime | DEFAULT CURRENT_TIMESTAMP |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_pedido`),
UNIQUE KEY `codigo_interno` (`codigo_interno`),
KEY `fk_exame_senha` (`id_senha`),
KEY `fk_exame_ffa` (`id_ffa`),
KEY `fk_exame_atendimento` (`id_atendimento`)
/*!40000 ALTER TABLE `exame_pedido` DISABLE KEYS */;
/*!40000 ALTER TABLE `exame_pedido` ENABLE KEYS */;
