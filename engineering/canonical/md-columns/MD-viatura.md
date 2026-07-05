# MD-viatura-colunas — Colunas

## Tabela: `viatura`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_viatura` | bigint | NOT NULL AUTO_INCREMENT |
| `id_unidade` | bigint | unsigned NOT NULL |
| `prefixo` | varchar(30) | NOT NULL |
| `tipo` | enum('AMBULANCIA_BASICA','AMBULANCIA_AVANCADA','OUTRO') | NOT NULL DEFAULT 'OUTRO' |
| `ativo` | tinyint(1) | DEFAULT '1' |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_viatura`),
UNIQUE KEY `uk_viatura` (`id_unidade`,`prefixo`),
CONSTRAINT `fk_viatura_unidade` FOREIGN KEY (`id_unidade`) REFERENCES `unidade` (`id_unidade`)
/*!40000 ALTER TABLE `viatura` DISABLE KEYS */;
/*!40000 ALTER TABLE `viatura` ENABLE KEYS */;
