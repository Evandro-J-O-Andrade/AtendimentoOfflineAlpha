# MD-exame_historico-colunas — Colunas

## Tabela: `exame_historico`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id` | bigint | NOT NULL AUTO_INCREMENT |
| `id_pedido` | bigint | NOT NULL |
| `evento` | enum('SOLICITACAO','COLETA','RECEBIMENTO','LAUDO','CANCELAMENTO') | NOT NULL |
| `id_usuario` | bigint | NOT NULL |
| `criado_em` | datetime | DEFAULT CURRENT_TIMESTAMP |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id`),
KEY `idx_pedido_hist` (`id_pedido`),
CONSTRAINT `fk_hist_exame_pedido` FOREIGN KEY (`id_pedido`) REFERENCES `exame_pedido` (`id_pedido`)
/*!40000 ALTER TABLE `exame_historico` DISABLE KEYS */;
/*!40000 ALTER TABLE `exame_historico` ENABLE KEYS */;
