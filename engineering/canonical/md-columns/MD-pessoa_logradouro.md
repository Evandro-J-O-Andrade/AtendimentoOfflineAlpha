# MD-pessoa_logradouro-colunas — Colunas

## Tabela: `pessoa_logradouro`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_pessoa` | bigint | NOT NULL |
| `id_logradouro` | bigint | NOT NULL |
| `principal` | tinyint(1) | DEFAULT '1' |
| `data_inicio` | date | NOT NULL |
| `data_fim` | date | DEFAULT NULL |
| `ativo` | tinyint(1) | DEFAULT '1' |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_pessoa`,`id_logradouro`,`data_inicio`),
KEY `id_logradouro` (`id_logradouro`),
KEY `idx_pessoa_logradouro_ativo` (`id_pessoa`,`ativo`),
KEY `idx_pessoa_logradouro_principal` (`id_pessoa`,`principal`),
CONSTRAINT `pessoa_logradouro_ibfk_1` FOREIGN KEY (`id_pessoa`) REFERENCES `pessoa` (`id_pessoa`),
CONSTRAINT `pessoa_logradouro_ibfk_2` FOREIGN KEY (`id_logradouro`) REFERENCES `logradouro` (`id_logradouro`)
/*!40000 ALTER TABLE `pessoa_logradouro` DISABLE KEYS */;
/*!40000 ALTER TABLE `pessoa_logradouro` ENABLE KEYS */;
