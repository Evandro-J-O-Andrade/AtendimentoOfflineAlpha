# MD-plantao_escala-colunas — Colunas

## Tabela: `plantao_escala`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_plantao_escala` | bigint | NOT NULL AUTO_INCREMENT |
| `id_unidade` | bigint | unsigned NOT NULL |
| `id_funcionario` | bigint | NOT NULL |
| `data` | date | NOT NULL |
| `turno` | varchar(30) | NOT NULL |
| `id_plantao_modelo` | bigint | DEFAULT NULL |
| `tipo_plantao` | enum('CLINICO','PEDIATRIA','EMERGENCIA','ADMINISTRATIVO','OUTRO') | DEFAULT NULL |
| `ativo` | tinyint(1) | DEFAULT '1' |
| `criado_em` | datetime(6) | DEFAULT CURRENT_TIMESTAMP(6) |
| `atualizado_em` | datetime(6) | DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP(6) |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_plantao_escala`),
UNIQUE KEY `uk_plantao_escala_global` (`id_unidade`,`id_funcionario`,`data`,`turno`),
KEY `idx_pe_unidade_data` (`id_unidade`,`data`),
KEY `idx_pe_funcionario` (`id_funcionario`),
KEY `fk_plantao_escala_modelo` (`id_plantao_modelo`),
CONSTRAINT `fk_plantao_escala_funcionario` FOREIGN KEY (`id_funcionario`) REFERENCES `funcionario` (`id_funcionario`) ON DELETE RESTRICT ON UPDATE CASCADE,
CONSTRAINT `fk_plantao_escala_modelo` FOREIGN KEY (`id_plantao_modelo`) REFERENCES `plantao_modelo` (`id_plantao_modelo`) ON DELETE SET NULL ON UPDATE CASCADE,
CONSTRAINT `fk_plantao_escala_unidade` FOREIGN KEY (`id_unidade`) REFERENCES `unidade` (`id_unidade`)
/*!40000 ALTER TABLE `plantao_escala` DISABLE KEYS */;
/*!40000 ALTER TABLE `plantao_escala` ENABLE KEYS */;
