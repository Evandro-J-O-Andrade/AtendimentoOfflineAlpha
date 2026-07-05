# MD-codigo_prefixo_regra-colunas — Colunas

## Tabela: `codigo_prefixo_regra`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_regra` | bigint | NOT NULL AUTO_INCREMENT |
| `tipo` | varchar(30) | NOT NULL |
| `id_unidade` | bigint | unsigned NOT NULL |
| `id_local_operacional` | bigint | DEFAULT NULL |
| `prefixo5` | char(5) | NOT NULL |
| `ativo` | tinyint(1) | NOT NULL DEFAULT '1' |
| `observacao` | varchar(255) | DEFAULT NULL |
| `criado_em` | datetime | NOT NULL DEFAULT CURRENT_TIMESTAMP |
| `atualizado_em` | datetime | DEFAULT NULL |
| `id_entidade` | bigint | unsigned DEFAULT NULL |

---

## Índices

PRIMARY KEY (`id_regra`),
UNIQUE KEY `uk_prefixo_tipo_ctx` (`tipo`,`id_unidade`,`id_local_operacional`),
KEY `ix_prefixo_tipo` (`tipo`),
KEY `ix_prefixo_prefixo` (`prefixo5`),
KEY `fk_codigo_prefixo_regra_unidade` (`id_unidade`),
CONSTRAINT `fk_codigo_prefixo_regra_unidade` FOREIGN KEY (`id_unidade`) REFERENCES `unidade` (`id_unidade`)
/*!40000 ALTER TABLE `codigo_prefixo_regra` DISABLE KEYS */;
/*!40000 ALTER TABLE `codigo_prefixo_regra` ENABLE KEYS */;
