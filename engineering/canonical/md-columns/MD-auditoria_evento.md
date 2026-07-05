# MD-auditoria_evento-colunas — Colunas

## Tabela: `auditoria_evento`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_auditoria` | bigint | NOT NULL AUTO_INCREMENT |
| `id_usuario` | bigint | NOT NULL |
| `id_sessao_usuario` | bigint | NOT NULL |
| `dominio` | varchar(50) | NOT NULL |
| `tipo_evento` | varchar(100) | NOT NULL |
| `id_referencia` | bigint | DEFAULT NULL |
| `payload` | json | DEFAULT NULL |
| `metadata` | json | DEFAULT NULL |
| `criado_em` | datetime(6) | NOT NULL |
| `status` | varchar(20) | DEFAULT 'OK' |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_auditoria`),
KEY `idx_usuario` (`id_usuario`),
KEY `idx_sessao` (`id_sessao_usuario`),
KEY `idx_dominio_tipo` (`dominio`,`tipo_evento`),
KEY `idx_referencia` (`id_referencia`)
/*!40000 ALTER TABLE `auditoria_evento` DISABLE KEYS */;
/*!40000 ALTER TABLE `auditoria_evento` ENABLE KEYS */;
