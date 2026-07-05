# MD-plantao-colunas — Colunas

## Tabela: `plantao`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_plantao` | bigint | NOT NULL AUTO_INCREMENT |
| `id_unidade` | bigint | unsigned NOT NULL |
| `id_local` | bigint | DEFAULT NULL |
| `id_funcionario` | bigint | NOT NULL |
| `tipo_plantao` | enum('CLINICO','PEDIATRIA','EMERGENCIA','ADMINISTRATIVO','OUTRO') | NOT NULL |
| `inicio_plantao` | datetime | NOT NULL |
| `fim_plantao` | datetime | NOT NULL |
| `ativo` | tinyint(1) | DEFAULT '1' |
| `criado_em` | datetime(6) | DEFAULT CURRENT_TIMESTAMP(6) |
| `atualizado_em` | datetime(6) | DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP(6) |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_plantao`),
KEY `idx_plantao_global` (`id_unidade`,`ativo`,`inicio_plantao`,`fim_plantao`),
KEY `idx_plantao_funcionario` (`id_funcionario`),
KEY `idx_plantao_local` (`id_local`),
CONSTRAINT `fk_plantao_funcionario` FOREIGN KEY (`id_funcionario`) REFERENCES `funcionario` (`id_funcionario`) ON DELETE RESTRICT ON UPDATE CASCADE,
CONSTRAINT `fk_plantao_local` FOREIGN KEY (`id_local`) REFERENCES `local` (`id_local`) ON DELETE SET NULL ON UPDATE CASCADE,
CONSTRAINT `fk_plantao_unidade` FOREIGN KEY (`id_unidade`) REFERENCES `unidade` (`id_unidade`)
/*!40000 ALTER TABLE `plantao` DISABLE KEYS */;
/*!40000 ALTER TABLE `plantao` ENABLE KEYS */;
