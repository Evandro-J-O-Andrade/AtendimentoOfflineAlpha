# MD-funcionario_especialidade-colunas — Colunas

## Tabela: `funcionario_especialidade`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_funcionario_especialidade` | bigint | NOT NULL AUTO_INCREMENT |
| `id_funcionario` | bigint | NOT NULL |
| `especialidade` | varchar(150) | NOT NULL |
| `principal` | tinyint(1) | DEFAULT '0' |
| `criado_em` | datetime(6) | DEFAULT CURRENT_TIMESTAMP(6) |
| `id_entidade` | bigint | unsigned DEFAULT NULL |

---

## Índices

PRIMARY KEY (`id_funcionario_especialidade`),
KEY `idx_fe_funcionario` (`id_funcionario`),
CONSTRAINT `fk_fe_funcionario` FOREIGN KEY (`id_funcionario`) REFERENCES `funcionario` (`id_funcionario`)
/*!40000 ALTER TABLE `funcionario_especialidade` DISABLE KEYS */;
/*!40000 ALTER TABLE `funcionario_especialidade` ENABLE KEYS */;
