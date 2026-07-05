# MD-estoque_evento_confirmacao-colunas — Colunas

## Tabela: `estoque_evento_confirmacao`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_evento` | bigint | NOT NULL AUTO_INCREMENT |
| `hash_execucao` | char(64) | NOT NULL |
| `id_movimento` | bigint | NOT NULL |
| `id_usuario_executor` | bigint | NOT NULL |
| `id_usuario_confirmador` | bigint | DEFAULT NULL |
| `tipo_evento` | varchar(50) | NOT NULL |
| `status_confirmacao` | enum('PENDENTE','CONFIRMADO','REJEITADO') | NOT NULL DEFAULT 'PENDENTE' |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_evento`),
UNIQUE KEY `uk_evento_execucao` (`hash_execucao`),
KEY `idx_evento_movimento` (`id_movimento`),
KEY `idx_evento_status` (`status_confirmacao`)
/*!40000 ALTER TABLE `estoque_evento_confirmacao` DISABLE KEYS */;
/*!40000 ALTER TABLE `estoque_evento_confirmacao` ENABLE KEYS */;
