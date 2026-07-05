# MD-sinan_evento-colunas — Colunas

## Tabela: `sinan_evento`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_sinan_evento` | bigint | NOT NULL AUTO_INCREMENT |
| `id_sinan` | bigint | NOT NULL |
| `id_sessao_usuario` | bigint | NOT NULL |
| `evento` | varchar(50) | NOT NULL |
| `payload_json` | json | DEFAULT NULL |
| `criado_em` | datetime | NOT NULL DEFAULT CURRENT_TIMESTAMP |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_sinan_evento`),
KEY `ix_sinan_evento_sinan` (`id_sinan`),
KEY `ix_sinan_evento_evt` (`evento`)
/*!40000 ALTER TABLE `sinan_evento` DISABLE KEYS */;
/*!40000 ALTER TABLE `sinan_evento` ENABLE KEYS */;
