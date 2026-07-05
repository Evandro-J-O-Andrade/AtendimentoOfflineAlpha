# MD-md_arquivo_fonte-colunas — Colunas

## Tabela: `md_arquivo_fonte`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_md_arquivo_fonte` | bigint | NOT NULL AUTO_INCREMENT |
| `tipo` | enum('CID10','CNES','SIGTAP','SIGPAT','OUTRO') | NOT NULL |
| `competencia` | char(6) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL |
| `origem` | varchar(120) | DEFAULT NULL |
| `descricao` | varchar(255) | DEFAULT NULL |
| `url_origem` | varchar(255) | DEFAULT NULL |
| `nome_arquivo` | varchar(200) | DEFAULT NULL |
| `tamanho_bytes` | bigint | DEFAULT NULL |
| `sha256` | char(64) | DEFAULT NULL |
| `baixado_em` | datetime | DEFAULT NULL |
| `processado_em` | datetime | DEFAULT NULL |
| `status` | enum('PENDENTE','BAIXADO','PROCESSADO','ERRO') | NOT NULL DEFAULT 'PENDENTE' |
| `mensagem_erro` | varchar(500) | DEFAULT NULL |
| `criado_em` | datetime | NOT NULL DEFAULT CURRENT_TIMESTAMP |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_md_arquivo_fonte`),
KEY `idx_md_fonte_tipo_comp` (`tipo`,`competencia`),
KEY `idx_md_fonte_status` (`status`),
KEY `idx_md_fonte_sha` (`sha256`),
KEY `fk_md_fonte_competencia` (`competencia`),
CONSTRAINT `fk_md_fonte_competencia` FOREIGN KEY (`competencia`) REFERENCES `md_competencia` (`competencia`)
/*!40000 ALTER TABLE `md_arquivo_fonte` DISABLE KEYS */;
/*!40000 ALTER TABLE `md_arquivo_fonte` ENABLE KEYS */;
