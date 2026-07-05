# MD-auditoria_ffa-colunas — Colunas

## Tabela: `auditoria_ffa`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id` | bigint | NOT NULL AUTO_INCREMENT |
| `id_ffa` | bigint | NOT NULL |
| `id_usuario` | bigint | NOT NULL |
| `tipo_evento` | enum('CRIACAO','STATUS','LAYOUT','CHAMADA_MEDICA','SOLICITACAO_RX','SOLICITACAO_MEDICACAO','ALTA_MEDICA','TRANSFERENCIA','INTERNACAO') | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL |
| `acao` | varchar(255) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL |
| `timestamp` | datetime | NOT NULL DEFAULT CURRENT_TIMESTAMP |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id`),
KEY `fk_auditoria_ffa_ffa` (`id_ffa`)
/*!40000 ALTER TABLE `auditoria_ffa` DISABLE KEYS */;
/*!40000 ALTER TABLE `auditoria_ffa` ENABLE KEYS */;
