# MD-estoque_reserva_evento-colunas — Colunas

## Tabela: `estoque_reserva_evento`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_evento` | bigint | NOT NULL AUTO_INCREMENT |
| `id_reserva` | bigint | NOT NULL |
| `id_sessao_usuario` | bigint | NOT NULL |
| `tipo_evento` | enum('CRIAR','FINALIZAR','CANCELAR','GERAR_MOVIMENTO','ERRO') | NOT NULL |
| `hash_anterior` | char(64) | DEFAULT NULL |
| `hash_atual` | char(64) | NOT NULL |
| `criado_em` | datetime | NOT NULL DEFAULT CURRENT_TIMESTAMP |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_evento`),
KEY `fk_evento_reserva` (`id_reserva`),
KEY `fk_evento_sessao` (`id_sessao_usuario`),
CONSTRAINT `fk_evento_reserva` FOREIGN KEY (`id_reserva`) REFERENCES `estoque_reserva` (`id_reserva`)
/*!40000 ALTER TABLE `estoque_reserva_evento` DISABLE KEYS */;
/*!40000 ALTER TABLE `estoque_reserva_evento` ENABLE KEYS */;
