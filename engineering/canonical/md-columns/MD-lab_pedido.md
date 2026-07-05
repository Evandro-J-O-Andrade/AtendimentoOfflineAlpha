# MD-lab_pedido-colunas — Colunas

## Tabela: `lab_pedido`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_pedido` | bigint | NOT NULL AUTO_INCREMENT |
| `protocolo_interno` | varchar(30) | NOT NULL |
| `id_senha` | bigint | NOT NULL |
| `id_ffa` | bigint | NOT NULL |
| `id_atendimento` | bigint | DEFAULT NULL |
| `id_laboratorio` | int | NOT NULL |
| `status` | enum('SOLICITADO','COLETADO','ENVIADO','RECEBIDO_LAB','FINALIZADO','CANCELADO') | DEFAULT 'SOLICITADO' |
| `impresso` | tinyint(1) | DEFAULT '0' |
| `criado_em` | datetime | DEFAULT CURRENT_TIMESTAMP |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_pedido`),
UNIQUE KEY `protocolo_interno` (`protocolo_interno`),
KEY `fk_lab_senha` (`id_senha`),
KEY `fk_lab_ffa` (`id_ffa`)
/*!40000 ALTER TABLE `lab_pedido` DISABLE KEYS */;
/*!40000 ALTER TABLE `lab_pedido` ENABLE KEYS */;
