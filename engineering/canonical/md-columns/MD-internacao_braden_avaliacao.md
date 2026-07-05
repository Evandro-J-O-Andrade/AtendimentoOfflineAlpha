# MD-internacao_braden_avaliacao-colunas — Colunas

## Tabela: `internacao_braden_avaliacao`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_internacao_braden_avaliacao` | bigint | NOT NULL AUTO_INCREMENT |
| `id_internacao` | bigint | NOT NULL |
| `data_hora` | datetime | NOT NULL DEFAULT CURRENT_TIMESTAMP |
| `risco` | enum('SEM_RISCO','LEVE','MODERADO','ALTO','MUITO_ALTO') | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL |
| `observacoes` | text | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci |
| `id_documento` | bigint | DEFAULT NULL |
| `id_usuario_responsavel` | bigint | NOT NULL |
| `id_sessao_usuario` | bigint | NOT NULL |
| `criado_em` | datetime | NOT NULL DEFAULT CURRENT_TIMESTAMP |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_internacao_braden_avaliacao`),
KEY `idx_iba_internacao` (`id_internacao`),
KEY `idx_iba_data_hora` (`data_hora`),
KEY `idx_iba_usuario` (`id_usuario_responsavel`),
KEY `idx_iba_sessao` (`id_sessao_usuario`),
KEY `idx_iba_documento` (`id_documento`),
CONSTRAINT `fk_iba_documento` FOREIGN KEY (`id_documento`) REFERENCES `documento_emissao` (`id_documento`),
CONSTRAINT `fk_iba_internacao` FOREIGN KEY (`id_internacao`) REFERENCES `internacao` (`id_internacao`),
CONSTRAINT `fk_iba_usuario` FOREIGN KEY (`id_usuario_responsavel`) REFERENCES `usuario` (`id_usuario`),
/*!40000 ALTER TABLE `internacao_braden_avaliacao` DISABLE KEYS */;
/*!40000 ALTER TABLE `internacao_braden_avaliacao` ENABLE KEYS */;
