# MD-documento_emissao-colunas — Colunas

## Tabela: `documento_emissao`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_documento` | bigint | NOT NULL AUTO_INCREMENT |
| `id_ffa` | bigint | DEFAULT NULL |
| `id_paciente` | bigint | DEFAULT NULL |
| `id_senha` | bigint | DEFAULT NULL |
| `gpat` | varchar(30) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL |
| `tipo_documento` | varchar(60) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL |
| `entidade_ref` | varchar(30) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL |
| `id_ref` | bigint | DEFAULT NULL |
| `numero_documento` | varchar(40) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL |
| `hash_documento` | varchar(64) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL |
| `status` | enum('GERADO','IMPRESSO','CANCELADO') | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'GERADO' |
| `id_sessao_usuario` | bigint | NOT NULL |
| `id_usuario` | bigint | NOT NULL |
| `id_unidade` | bigint | unsigned NOT NULL |
| `id_local_operacional` | bigint | DEFAULT NULL |
| `observacao` | text | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci |
| `criado_em` | datetime | NOT NULL DEFAULT CURRENT_TIMESTAMP |
| `atualizado_em` | datetime | DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_documento`),
UNIQUE KEY `ux_doc_tipo_ref` (`tipo_documento`,`entidade_ref`,`id_ref`),
KEY `idx_doc_ffa` (`id_ffa`),
KEY `idx_doc_paciente` (`id_paciente`),
KEY `idx_doc_tipo` (`tipo_documento`),
KEY `idx_doc_status` (`status`),
KEY `idx_doc_gpat` (`gpat`),
KEY `idx_doc_data` (`criado_em`),
KEY `fk_doc_sessao` (`id_sessao_usuario`),
KEY `fk_documento_emissao_unidade` (`id_unidade`),
CONSTRAINT `fk_documento_emissao_unidade` FOREIGN KEY (`id_unidade`) REFERENCES `unidade` (`id_unidade`)
/*!40000 ALTER TABLE `documento_emissao` DISABLE KEYS */;
/*!40000 ALTER TABLE `documento_emissao` ENABLE KEYS */;
