# MD-funcionario_unidade-colunas — Colunas

## Tabela: `funcionario_unidade`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_funcionario_unidade` | bigint | NOT NULL AUTO_INCREMENT |
| `id_funcionario` | bigint | NOT NULL |
| `id_unidade` | bigint | unsigned NOT NULL |
| `funcao_unidade` | varchar(150) | DEFAULT NULL |
| `data_inicio` | date | DEFAULT NULL |
| `data_fim` | date | DEFAULT NULL |
| `ativo` | tinyint(1) | DEFAULT '1' |
| `criado_em` | datetime(6) | DEFAULT CURRENT_TIMESTAMP(6) |
| `atualizado_em` | datetime(6) | DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP(6) |
| `id_entidade` | bigint | unsigned DEFAULT NULL |

---

## Índices

PRIMARY KEY (`id_funcionario_unidade`),
KEY `idx_fu_funcionario` (`id_funcionario`),
KEY `idx_fu_unidade` (`id_unidade`),
CONSTRAINT `fk_fu_funcionario` FOREIGN KEY (`id_funcionario`) REFERENCES `funcionario` (`id_funcionario`),
CONSTRAINT `fk_funcionario_unidade_unidade` FOREIGN KEY (`id_unidade`) REFERENCES `unidade` (`id_unidade`)
/*!40000 ALTER TABLE `funcionario_unidade` DISABLE KEYS */;
/*!40000 ALTER TABLE `funcionario_unidade` ENABLE KEYS */;
