# MD-pedido_medico-colunas — Colunas

## Tabela: `pedido_medico`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_pedido_medico` | bigint | NOT NULL AUTO_INCREMENT |
| `id_ffa` | bigint | NOT NULL |
| `id_gpat` | bigint | NOT NULL |
| `id_usuario_solicitante` | bigint | NOT NULL |
| `id_local_operacional` | bigint | DEFAULT NULL |
| `status` | enum('ABERTO','EM_EXECUCAO','CONCLUIDO','CANCELADO') | NOT NULL DEFAULT 'ABERTO' |
| `justificativa` | varchar(500) | DEFAULT NULL |
| `criado_em` | datetime | NOT NULL DEFAULT CURRENT_TIMESTAMP |
| `atualizado_em` | datetime | DEFAULT NULL |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_pedido_medico`),
KEY `ix_pedido_medico_ffa` (`id_ffa`),
KEY `ix_pedido_medico_status` (`status`),
KEY `ix_pedido_medico_gpat` (`id_gpat`)
/*!40000 ALTER TABLE `pedido_medico` DISABLE KEYS */;
/*!40000 ALTER TABLE `pedido_medico` ENABLE KEYS */;
