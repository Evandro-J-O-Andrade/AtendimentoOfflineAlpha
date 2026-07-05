# MD-reg_export_item-colunas — Colunas

## Tabela: `reg_export_item`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_export_item` | bigint | NOT NULL AUTO_INCREMENT |
| `id_export_lote` | bigint | NOT NULL |
| `entidade_ref` | varchar(80) | NOT NULL |
| `id_ref` | bigint | NOT NULL |
| `status` | enum('PENDENTE','GERADO','ENVIADO','ERRO','CONFIRMADO','CANCELADO') | NOT NULL DEFAULT 'PENDENTE' |
| `payload_hash` | char(64) | DEFAULT NULL |
| `protocolo_externo` | varchar(80) | DEFAULT NULL |
| `tentativas` | int | NOT NULL DEFAULT '0' |
| `ultima_tentativa_em` | datetime | DEFAULT NULL |
| `criado_em` | datetime | NOT NULL DEFAULT CURRENT_TIMESTAMP |
| `atualizado_em` | datetime | NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_export_item`),
UNIQUE KEY `uk_reg_item_lote_ref` (`id_export_lote`,`entidade_ref`,`id_ref`),
KEY `idx_reg_item_status` (`status`),
KEY `idx_reg_item_ref` (`entidade_ref`,`id_ref`),
CONSTRAINT `fk_reg_item_lote` FOREIGN KEY (`id_export_lote`) REFERENCES `reg_export_lote` (`id_export_lote`)
/*!40000 ALTER TABLE `reg_export_item` DISABLE KEYS */;
/*!40000 ALTER TABLE `reg_export_item` ENABLE KEYS */;
