# MD-estoque_reserva-colunas — Colunas

## Tabela: `estoque_reserva`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_reserva` | bigint | NOT NULL AUTO_INCREMENT |
| `id_estoque_local` | bigint | NOT NULL |
| `id_produto` | bigint | NOT NULL |
| `id_lote` | bigint | NOT NULL |
| `quantidade` | decimal(15,4) | NOT NULL |
| `origem_tipo` | enum('FARM_DISP','PDV','AJUSTE','TRANSFERENCIA','OUTRO') | NOT NULL |
| `id_documento_origem` | bigint | DEFAULT NULL |
| `status` | enum('ATIVA','FINALIZADA','CANCELADA') | NOT NULL DEFAULT 'ATIVA' |
| `hash_anterior` | char(64) | DEFAULT NULL |
| `hash_atual` | char(64) | NOT NULL |
| `id_sessao_usuario` | bigint | NOT NULL |
| `criado_em` | datetime | NOT NULL DEFAULT CURRENT_TIMESTAMP |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_reserva`),
KEY `fk_reserva_local` (`id_estoque_local`),
KEY `fk_reserva_produto` (`id_produto`),
KEY `fk_reserva_lote` (`id_lote`),
KEY `fk_reserva_sessao` (`id_sessao_usuario`),
CONSTRAINT `fk_reserva_local` FOREIGN KEY (`id_estoque_local`) REFERENCES `estoque_local` (`id_estoque_local`),
CONSTRAINT `fk_reserva_lote` FOREIGN KEY (`id_lote`) REFERENCES `estoque_lote` (`id_lote`),
CONSTRAINT `fk_reserva_produto` FOREIGN KEY (`id_produto`) REFERENCES `estoque_produto` (`id_produto`)
/*!40000 ALTER TABLE `estoque_reserva` DISABLE KEYS */;
/*!40000 ALTER TABLE `estoque_reserva` ENABLE KEYS */;
