# MD-pedido_medico_item-colunas — Colunas

## Tabela: `pedido_medico_item`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_pedido_item` | bigint | NOT NULL AUTO_INCREMENT |
| `id_pedido_medico` | bigint | NOT NULL |
| `tipo_item` | enum('PROCEDIMENTO','EXAME','MEDICACAO','ENCAMINHAMENTO','OUTRO') | NOT NULL |
| `status` | enum('PENDENTE','EM_EXECUCAO','CONCLUIDO','CANCELADO','SUSPENSO') | NOT NULL DEFAULT 'PENDENTE' |
| `codigo_sigtap` | varchar(30) | DEFAULT NULL |
| `competencia_sigtap` | char(6) | DEFAULT NULL |
| `cid10_principal` | varchar(10) | DEFAULT NULL |
| `cnes_executante` | varchar(20) | DEFAULT NULL |
| `id_codigo_universal` | bigint | DEFAULT NULL |
| `sistema_externo` | varchar(50) | DEFAULT NULL |
| `codigo_externo` | varchar(80) | DEFAULT NULL |
| `descricao` | varchar(500) | DEFAULT NULL |
| `exige_cat` | tinyint(1) | NOT NULL DEFAULT '0' |
| `exige_sinan` | tinyint(1) | NOT NULL DEFAULT '0' |
| `criado_em` | datetime | NOT NULL DEFAULT CURRENT_TIMESTAMP |
| `atualizado_em` | datetime | DEFAULT NULL |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_pedido_item`),
UNIQUE KEY `uk_pedido_item_externo` (`sistema_externo`,`codigo_externo`),
KEY `ix_pedido_item_pedido` (`id_pedido_medico`),
KEY `ix_pedido_item_tipo` (`tipo_item`),
KEY `ix_pedido_item_status` (`status`)
/*!40000 ALTER TABLE `pedido_medico_item` DISABLE KEYS */;
/*!40000 ALTER TABLE `pedido_medico_item` ENABLE KEYS */;
