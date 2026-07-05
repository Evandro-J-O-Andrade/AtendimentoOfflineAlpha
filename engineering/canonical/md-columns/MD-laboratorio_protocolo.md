# MD-laboratorio_protocolo-colunas — Colunas

## Tabela: `laboratorio_protocolo`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_laboratorio_protocolo` | bigint | NOT NULL AUTO_INCREMENT |
| `id_ffa` | bigint | NOT NULL |
| `id_gpat` | bigint | NOT NULL |
| `id_pedido_item` | bigint | NOT NULL |
| `id_codigo_universal` | bigint | NOT NULL |
| `codigo` | varchar(60) | NOT NULL |
| `barcode` | varchar(60) | NOT NULL |
| `status` | enum('GERADO','COLETADO','ENVIADO','RECEBIDO','RESULTADO','CANCELADO') | NOT NULL DEFAULT 'GERADO' |
| `sistema_externo` | varchar(50) | DEFAULT NULL |
| `codigo_externo` | varchar(80) | DEFAULT NULL |
| `criado_em` | datetime | NOT NULL DEFAULT CURRENT_TIMESTAMP |
| `atualizado_em` | datetime | DEFAULT NULL |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_laboratorio_protocolo`),
UNIQUE KEY `uk_lab_codigo` (`codigo`),
UNIQUE KEY `uk_lab_item` (`id_pedido_item`),
KEY `ix_lab_ffa` (`id_ffa`),
KEY `ix_lab_gpat` (`id_gpat`),
KEY `ix_lab_status` (`status`)
/*!40000 ALTER TABLE `laboratorio_protocolo` DISABLE KEYS */;
/*!40000 ALTER TABLE `laboratorio_protocolo` ENABLE KEYS */;
