# MD-profissional_registro-colunas — Colunas

## Tabela: `profissional_registro`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_profissional_registro` | bigint | NOT NULL AUTO_INCREMENT |
| `id_funcionario` | bigint | NOT NULL |
| `tipo_conselho` | enum('CRM','COREN','CRF','CREFITO','CRN','CRP','OUTRO') | NOT NULL |
| `numero_registro` | varchar(50) | NOT NULL |
| `uf_registro` | char(2) | NOT NULL |
| `data_emissao` | date | DEFAULT NULL |
| `data_validade` | date | DEFAULT NULL |
| `ativo` | tinyint(1) | DEFAULT '1' |
| `criado_em` | datetime(6) | DEFAULT CURRENT_TIMESTAMP(6) |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_profissional_registro`),
KEY `idx_pr_funcionario` (`id_funcionario`),
CONSTRAINT `fk_pr_funcionario` FOREIGN KEY (`id_funcionario`) REFERENCES `funcionario` (`id_funcionario`)
/*!40000 ALTER TABLE `profissional_registro` DISABLE KEYS */;
/*!40000 ALTER TABLE `profissional_registro` ENABLE KEYS */;
