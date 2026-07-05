# MD-laboratorio_protocolo_evento-colunas — Colunas

## Tabela: `laboratorio_protocolo_evento`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_evento` | bigint | NOT NULL AUTO_INCREMENT |
| `id_laboratorio_protocolo` | bigint | NOT NULL |
| `id_sessao_usuario` | bigint | NOT NULL |
| `evento` | varchar(40) | NOT NULL |
| `detalhe` | varchar(255) | DEFAULT NULL |
| `payload_json` | json | DEFAULT NULL |
| `criado_em` | datetime | NOT NULL DEFAULT CURRENT_TIMESTAMP |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_evento`),
KEY `ix_lab_evt_proto` (`id_laboratorio_protocolo`),
KEY `ix_lab_evt_evt` (`evento`)
/*!40000 ALTER TABLE `laboratorio_protocolo_evento` DISABLE KEYS */;
/*!40000 ALTER TABLE `laboratorio_protocolo_evento` ENABLE KEYS */;
