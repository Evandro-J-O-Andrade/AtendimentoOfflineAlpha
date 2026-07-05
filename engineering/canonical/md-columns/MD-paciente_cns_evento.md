# MD-paciente_cns_evento-colunas — Colunas

## Tabela: `paciente_cns_evento`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_evento` | bigint | NOT NULL AUTO_INCREMENT |
| `id_paciente_cns` | bigint | NOT NULL |
| `id_sessao_usuario` | bigint | NOT NULL |
| `evento` | varchar(40) | NOT NULL |
| `detalhe` | varchar(255) | DEFAULT NULL |
| `payload_json` | json | DEFAULT NULL |
| `criado_em` | datetime | NOT NULL DEFAULT CURRENT_TIMESTAMP |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_evento`),
KEY `ix_pcns_evt` (`id_paciente_cns`),
KEY `ix_pcns_evt_tipo` (`evento`)
/*!40000 ALTER TABLE `paciente_cns_evento` DISABLE KEYS */;
/*!40000 ALTER TABLE `paciente_cns_evento` ENABLE KEYS */;
