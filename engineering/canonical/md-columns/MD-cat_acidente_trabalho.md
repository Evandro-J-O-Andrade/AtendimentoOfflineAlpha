# MD-cat_acidente_trabalho-colunas — Colunas

## Tabela: `cat_acidente_trabalho`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id` | bigint | NOT NULL AUTO_INCREMENT |
| `id_atendimento` | bigint | unsigned NOT NULL |
| `id_pessoa_trabalhador` | bigint | NOT NULL |
| `data_acidente` | datetime | NOT NULL |
| `tipo_acidente` | enum('TIPICO','TRAJETO','DOENCA_OCUPACIONAL','OUTRO') | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL |
| `descricao_acidente` | text | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci |
| `agente_causador` | varchar(120) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL |
| `parte_corpo` | varchar(120) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL |
| `cid10_relacionado` | varchar(10) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL |
| `status_cat` | enum('ABERTA','EMITIDA','ENVIADA','ARQUIVADA') | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'ABERTA' |
| `numero_cat` | varchar(40) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL |
| `id_sessao_usuario` | bigint | NOT NULL |
| `id_usuario_criador` | bigint | NOT NULL |
| `criado_em` | datetime | NOT NULL DEFAULT CURRENT_TIMESTAMP |
| `atualizado_em` | datetime | NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id`),
KEY `idx_cat_atendimento` (`id_atendimento`),
KEY `idx_cat_trabalhador` (`id_pessoa_trabalhador`),
KEY `idx_cat_status` (`status_cat`),
KEY `fk_cat_sessao` (`id_sessao_usuario`),
CONSTRAINT `fk_cat_trabalhador` FOREIGN KEY (`id_pessoa_trabalhador`) REFERENCES `pessoa` (`id_pessoa`)
/*!40000 ALTER TABLE `cat_acidente_trabalho` DISABLE KEYS */;
/*!40000 ALTER TABLE `cat_acidente_trabalho` ENABLE KEYS */;
