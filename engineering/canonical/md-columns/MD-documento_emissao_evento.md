# MD-documento_emissao_evento-colunas — Colunas

## Tabela: `documento_emissao_evento`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_evento` | bigint | NOT NULL AUTO_INCREMENT |
| `id_documento` | bigint | NOT NULL |
| `tipo` | enum('GERAR','IMPRIMIR','REIMPRIMIR','CANCELAR') | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL |
| `detalhe` | text | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci |
| `id_sessao_usuario` | bigint | NOT NULL |
| `id_usuario` | bigint | NOT NULL |
| `criado_em` | datetime | NOT NULL DEFAULT CURRENT_TIMESTAMP |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_evento`),
KEY `idx_doc_ev_doc` (`id_documento`),
KEY `idx_doc_ev_data` (`criado_em`),
KEY `fk_doc_ev_sessao` (`id_sessao_usuario`)
/*!40000 ALTER TABLE `documento_emissao_evento` DISABLE KEYS */;
/*!40000 ALTER TABLE `documento_emissao_evento` ENABLE KEYS */;
