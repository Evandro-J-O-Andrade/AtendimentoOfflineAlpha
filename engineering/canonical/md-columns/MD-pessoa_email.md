# MD-pessoa_email-colunas — Colunas

## Tabela: `pessoa_email`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_pessoa_email` | bigint | NOT NULL AUTO_INCREMENT |
| `id_pessoa` | bigint | NOT NULL |
| `email` | varchar(200) | NOT NULL |
| `tipo` | enum('PESSOAL','PROFISSIONAL','FINANCEIRO','EMERGENCIA','OUTRO') | DEFAULT 'PESSOAL' |
| `principal` | tinyint(1) | DEFAULT '0' |
| `verificado` | tinyint(1) | DEFAULT '0' |
| `ativo` | tinyint(1) | DEFAULT '1' |
| `valido_de` | date | DEFAULT NULL |
| `valido_ate` | date | DEFAULT NULL |
| `criado_em` | datetime(6) | DEFAULT CURRENT_TIMESTAMP(6) |
| `atualizado_em` | datetime(6) | DEFAULT NULL |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_pessoa_email`),
UNIQUE KEY `uk_email_unico` (`email`),
KEY `idx_email_pessoa` (`id_pessoa`),
KEY `idx_email_principal` (`principal`),
CONSTRAINT `fk_pessoa_email_pessoa` FOREIGN KEY (`id_pessoa`) REFERENCES `pessoa` (`id_pessoa`)
/*!40000 ALTER TABLE `pessoa_email` DISABLE KEYS */;
/*!40000 ALTER TABLE `pessoa_email` ENABLE KEYS */;
