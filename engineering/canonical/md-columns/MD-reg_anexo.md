# MD-reg_anexo-colunas — Colunas

## Tabela: `reg_anexo`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_anexo` | bigint | NOT NULL AUTO_INCREMENT |
| `entidade_ref` | varchar(80) | NOT NULL |
| `id_ref` | bigint | NOT NULL |
| `categoria` | enum('SINAN','CAT','DOCUMENTO','PRONTUARIO','OUTRO') | NOT NULL DEFAULT 'OUTRO' |
| `nome_arquivo` | varchar(200) | NOT NULL |
| `mime_type` | varchar(120) | DEFAULT NULL |
| `tamanho_bytes` | bigint | DEFAULT NULL |
| `sha256` | char(64) | DEFAULT NULL |
| `storage_uri` | varchar(255) | DEFAULT NULL |
| `id_sessao_usuario` | bigint | DEFAULT NULL |
| `id_usuario` | bigint | DEFAULT NULL |
| `criado_em` | datetime | NOT NULL DEFAULT CURRENT_TIMESTAMP |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_anexo`),
KEY `idx_reg_anexo_ref` (`entidade_ref`,`id_ref`),
KEY `idx_reg_anexo_sha` (`sha256`),
KEY `idx_reg_anexo_sessao` (`id_sessao_usuario`),
KEY `idx_reg_anexo_usuario` (`id_usuario`),
CONSTRAINT `fk_reg_anexo_usuario` FOREIGN KEY (`id_usuario`) REFERENCES `usuario` (`id_usuario`)
/*!40000 ALTER TABLE `reg_anexo` DISABLE KEYS */;
/*!40000 ALTER TABLE `reg_anexo` ENABLE KEYS */;
