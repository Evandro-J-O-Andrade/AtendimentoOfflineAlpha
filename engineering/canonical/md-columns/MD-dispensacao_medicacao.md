# MD-dispensacao_medicacao-colunas — Colunas

## Tabela: `dispensacao_medicacao`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_dispensacao` | bigint | NOT NULL AUTO_INCREMENT |
| `id_ordem` | bigint | NOT NULL |
| `id_item` | bigint | DEFAULT NULL |
| `id_farmaco` | bigint | NOT NULL |
| `id_lote` | bigint | NOT NULL |
| `quantidade` | decimal(10,2) | NOT NULL |
| `id_usuario_dispensador` | bigint | NOT NULL |
| `data_hora` | datetime | DEFAULT CURRENT_TIMESTAMP |
| `status` | enum('ENTREGUE','ESTORNADO') | DEFAULT 'ENTREGUE' |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_dispensacao`),
KEY `fk_disp_ordem` (`id_ordem`),
KEY `fk_disp_lote` (`id_lote`),
KEY `idx_disp_item` (`id_item`),
CONSTRAINT `fk_disp_item` FOREIGN KEY (`id_item`) REFERENCES `ordem_assistencial_item` (`id_item`)
/*!40000 ALTER TABLE `dispensacao_medicacao` DISABLE KEYS */;
/*!40000 ALTER TABLE `dispensacao_medicacao` ENABLE KEYS */;
