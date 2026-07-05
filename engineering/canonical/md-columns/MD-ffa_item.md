# MD-ffa_item-colunas — Colunas

## Tabela: `ffa_item`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_ffa_item` | bigint | NOT NULL AUTO_INCREMENT |
| `id_ffa` | bigint | NOT NULL |
| `id_paciente` | bigint | NOT NULL |
| `id_produto` | bigint | NOT NULL |
| `dose_prescrita` | decimal(15,4) | NOT NULL |
| `unidade_prescrita` | varchar(20) | NOT NULL |
| `quantidade_autorizada` | decimal(15,4) | NOT NULL |
| `quantidade_dispensada` | decimal(15,4) | NOT NULL DEFAULT '0.0000' |
| `status` | enum('PRESCRITO','AUTORIZADO','DISPENSADO_PARCIAL','DISPENSADO_TOTAL','CANCELADO') | NOT NULL DEFAULT 'PRESCRITO' |
| `id_unidade` | bigint | unsigned NOT NULL |
| `id_sessao_usuario` | bigint | NOT NULL |
| `criado_em` | datetime | NOT NULL DEFAULT CURRENT_TIMESTAMP |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_ffa_item`),
KEY `fk_ffa_produto` (`id_produto`),
KEY `fk_ffa_sessao` (`id_sessao_usuario`),
KEY `fk_ffa_item_unidade` (`id_unidade`),
CONSTRAINT `fk_ffa_item_unidade` FOREIGN KEY (`id_unidade`) REFERENCES `unidade` (`id_unidade`),
CONSTRAINT `fk_ffa_produto` FOREIGN KEY (`id_produto`) REFERENCES `estoque_produto` (`id_produto`)
/*!40000 ALTER TABLE `ffa_item` DISABLE KEYS */;
/*!40000 ALTER TABLE `ffa_item` ENABLE KEYS */;
