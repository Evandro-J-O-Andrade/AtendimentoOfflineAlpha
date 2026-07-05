# MD-sincronizacao_federada_evento-colunas — Colunas

## Tabela: `sincronizacao_federada_evento`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_sync` | bigint | NOT NULL AUTO_INCREMENT |
| `id_ffa` | bigint | NOT NULL |
| `evento` | varchar(60) | NOT NULL |
| `estado_origem` | varchar(60) | DEFAULT NULL |
| `estado_destino` | varchar(60) | DEFAULT NULL |
| `id_sessao_usuario` | bigint | DEFAULT NULL |
| `sincronizado` | tinyint(1) | DEFAULT '0' |
| `versao_logica` | bigint | DEFAULT '1' |
| `criado_em` | datetime(6) | DEFAULT CURRENT_TIMESTAMP(6) |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_sync`),
KEY `idx_sync_pendente` (`sincronizado`,`criado_em`)
/*!40000 ALTER TABLE `sincronizacao_federada_evento` DISABLE KEYS */;
/*!40000 ALTER TABLE `sincronizacao_federada_evento` ENABLE KEYS */;
