# MD-senha_sequencia-colunas — Colunas

## Tabela: `senha_sequencia`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_sistema` | bigint | NOT NULL |
| `id_unidade` | bigint | unsigned NOT NULL |
| `data_ref` | date | NOT NULL |
| `prefixo` | varchar(5) | NOT NULL |
| `ultimo_numero` | int | NOT NULL DEFAULT '0' |
| `id_entidade` | bigint | unsigned DEFAULT NULL |

---

## Índices

PRIMARY KEY (`id_sistema`,`id_unidade`,`data_ref`,`prefixo`),
KEY `fk_senha_sequencia_unidade` (`id_unidade`),
CONSTRAINT `fk_senha_sequencia_unidade` FOREIGN KEY (`id_unidade`) REFERENCES `unidade` (`id_unidade`)
/*!40000 ALTER TABLE `senha_sequencia` DISABLE KEYS */;
/*!40000 ALTER TABLE `senha_sequencia` ENABLE KEYS */;
