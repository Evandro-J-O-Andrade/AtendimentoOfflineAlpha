# MD-estoque_documento_execucao-colunas — Colunas

## Tabela: `estoque_documento_execucao`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id` | bigint | NOT NULL AUTO_INCREMENT |
| `hash_execucao` | char(64) | NOT NULL |
| `id_documento` | bigint | NOT NULL |
| `tipo_documento` | varchar(50) | NOT NULL |
| `id_movimento` | bigint | DEFAULT NULL |
| `id_sessao_usuario` | bigint | NOT NULL |
| `contexto_operacional` | varchar(100) | DEFAULT NULL |
| `estado_execucao` | enum('PENDENTE','EXECUTANDO','CONCLUIDO','FALHA') | NOT NULL DEFAULT 'PENDENTE' |
| `tentativa_execucao` | int | NOT NULL DEFAULT '1' |
| `hash_pipeline_anterior` | char(64) | DEFAULT NULL |
| `hash_pipeline_atual` | char(64) | DEFAULT NULL |
| `criado_em` | datetime | NOT NULL DEFAULT CURRENT_TIMESTAMP |
| `atualizado_em` | datetime | DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id`),
UNIQUE KEY `uk_hash_execucao` (`hash_execucao`),
UNIQUE KEY `uk_doc_tipo` (`id_documento`,`tipo_documento`),
KEY `idx_documento` (`id_documento`),
KEY `idx_movimento` (`id_movimento`),
KEY `idx_sessao` (`id_sessao_usuario`),
KEY `idx_estado` (`estado_execucao`),
KEY `idx_pipeline` (`hash_pipeline_atual`)
/*!40000 ALTER TABLE `estoque_documento_execucao` DISABLE KEYS */;
/*!40000 ALTER TABLE `estoque_documento_execucao` ENABLE KEYS */;
