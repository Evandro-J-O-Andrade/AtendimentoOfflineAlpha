# MD-cat_acidente_trabalho_evento-colunas — Colunas

## Tabela: `cat_acidente_trabalho_evento`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_evento` | bigint | NOT NULL AUTO_INCREMENT |
| `id_cat` | bigint | NOT NULL |
| `tipo_evento` | enum('CRIACAO','ALTERACAO','MUDANCA_STATUS','EXPORTACAO','ERRO') | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL |
| `status_anterior` | varchar(30) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL |
| `status_novo` | varchar(30) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL |
| `detalhes` | text | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci |
| `id_sessao_usuario` | bigint | NOT NULL |
| `id_usuario` | bigint | NOT NULL |
| `criado_em` | datetime | NOT NULL DEFAULT CURRENT_TIMESTAMP |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_evento`),
KEY `idx_cate_cat` (`id_cat`),
KEY `fk_cate_sessao` (`id_sessao_usuario`),
CONSTRAINT `fk_cate_cat` FOREIGN KEY (`id_cat`) REFERENCES `cat_acidente_trabalho` (`id`) ON DELETE CASCADE
/*!40000 ALTER TABLE `cat_acidente_trabalho_evento` DISABLE KEYS */;
/*!40000 ALTER TABLE `cat_acidente_trabalho_evento` ENABLE KEYS */;
