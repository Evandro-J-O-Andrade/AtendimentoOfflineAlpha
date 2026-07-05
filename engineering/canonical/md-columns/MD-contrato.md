# MD-contrato-colunas — Colunas

## Tabela: `contrato`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_contrato` | bigint | NOT NULL AUTO_INCREMENT |
| `nome` | varchar(100) | NOT NULL |
| `ativo` | tinyint(1) | DEFAULT '1' |
| `criado_em` | datetime | DEFAULT CURRENT_TIMESTAMP |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_contrato`)
/*!40000 ALTER TABLE `contrato` DISABLE KEYS */;
/*!40000 ALTER TABLE `contrato` ENABLE KEYS */;
