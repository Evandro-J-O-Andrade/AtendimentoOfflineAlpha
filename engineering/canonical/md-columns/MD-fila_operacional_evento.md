# MD-fila_operacional_evento-colunas — Colunas

## Tabela: `fila_operacional_evento`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_evento` | bigint | NOT NULL AUTO_INCREMENT |
| `id_fila` | bigint | NOT NULL |
| `id_sessao_usuario` | bigint | NOT NULL |
| `tipo_evento` | varchar(64) | NOT NULL |
| `criado_em` | datetime | NOT NULL DEFAULT CURRENT_TIMESTAMP |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_evento`),
KEY `idx_filaop_evt_fila` (`id_fila`),
KEY `idx_filaop_evt_sessao` (`id_sessao_usuario`),
CONSTRAINT `fk_filaop_evt_fila` FOREIGN KEY (`id_fila`) REFERENCES `fila_operacional` (`id_fila`),
CONSTRAINT `fk_filaop_evt_sessao` FOREIGN KEY (`id_sessao_usuario`) REFERENCES `sessao_usuario` (`id_sessao_usuario`)
/*!40000 ALTER TABLE `fila_operacional_evento` DISABLE KEYS */;
/*!40000 ALTER TABLE `fila_operacional_evento` ENABLE KEYS */;
