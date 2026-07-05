# MD-pessoa_identificador-colunas — Colunas

## Tabela: `pessoa_identificador`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_pessoa_identificador` | bigint | NOT NULL AUTO_INCREMENT |
| `id_pessoa` | bigint | NOT NULL |
| `tipo_identificador` | enum('MRN','CODIGO_INTERNO','CODIGO_LEGADO','CODIGO_MUNICIPAL','CODIGO_ESTADUAL','CODIGO_NACIONAL','CODIGO_CONVENIO','CODIGO_LABORATORIO','CODIGO_FARMACIA','CODIGO_SAAS','OUTRO') | NOT NULL |
| `identificador` | varchar(120) | NOT NULL |
| `sistema_origem` | varchar(100) | DEFAULT NULL |
| `descricao` | varchar(200) | DEFAULT NULL |
| `principal` | tinyint(1) | DEFAULT '0' |
| `ativo` | tinyint(1) | DEFAULT '1' |
| `criado_em` | datetime(6) | DEFAULT CURRENT_TIMESTAMP(6) |
| `atualizado_em` | datetime(6) | DEFAULT NULL |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_pessoa_identificador`),
KEY `idx_pid_pessoa` (`id_pessoa`),
KEY `idx_pid_tipo` (`tipo_identificador`),
KEY `idx_pid_identificador` (`identificador`),
CONSTRAINT `fk_pessoa_identificador_pessoa` FOREIGN KEY (`id_pessoa`) REFERENCES `pessoa` (`id_pessoa`)
/*!40000 ALTER TABLE `pessoa_identificador` DISABLE KEYS */;
/*!40000 ALTER TABLE `pessoa_identificador` ENABLE KEYS */;
