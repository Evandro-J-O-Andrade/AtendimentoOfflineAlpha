# MD-rh_evento-colunas — Colunas

## Tabela: `rh_evento`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_evento` | bigint | NOT NULL AUTO_INCREMENT |
| `id_rh_vinculo` | bigint | DEFAULT NULL |
| `id_registro` | bigint | DEFAULT NULL |
| `id_sessao_usuario` | bigint | NOT NULL |
| `evento` | varchar(50) | NOT NULL |
| `detalhe` | varchar(255) | DEFAULT NULL |
| `payload_json` | json | DEFAULT NULL |
| `criado_em` | datetime | NOT NULL DEFAULT CURRENT_TIMESTAMP |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_evento`),
KEY `ix_rh_evt_vinc` (`id_rh_vinculo`),
KEY `ix_rh_evt_reg` (`id_registro`),
KEY `ix_rh_evt_evt` (`evento`)
/*!40000 ALTER TABLE `rh_evento` DISABLE KEYS */;
/*!40000 ALTER TABLE `rh_evento` ENABLE KEYS */;
