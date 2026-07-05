# MD-administracao_medicacao_ordem-colunas — Colunas

## Tabela: `administracao_medicacao_ordem`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_administracao` | bigint | NOT NULL AUTO_INCREMENT |
| `id_item` | bigint | NOT NULL |
| `quantidade` | decimal(10,2) | NOT NULL |
| `realizado_em` | datetime | NOT NULL DEFAULT CURRENT_TIMESTAMP |
| `id_usuario` | bigint | NOT NULL |
| `id_sessao_usuario` | bigint | DEFAULT NULL |
| `id_local_operacional` | bigint | DEFAULT NULL |
| `id_aprazamento` | bigint | DEFAULT NULL |
| `observacao` | text | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci |
| `status` | enum('ADMINISTRADO','NAO_ADMINISTRADO','ESTORNADO') | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'ADMINISTRADO' |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_administracao`),
KEY `idx_admin_item` (`id_item`),
KEY `idx_admin_user` (`id_usuario`),
CONSTRAINT `fk_admin_item` FOREIGN KEY (`id_item`) REFERENCES `ordem_assistencial_item` (`id_item`),
CONSTRAINT `fk_admin_user` FOREIGN KEY (`id_usuario`) REFERENCES `usuario` (`id_usuario`)
/*!40000 ALTER TABLE `administracao_medicacao_ordem` DISABLE KEYS */;
/*!40000 ALTER TABLE `administracao_medicacao_ordem` ENABLE KEYS */;
