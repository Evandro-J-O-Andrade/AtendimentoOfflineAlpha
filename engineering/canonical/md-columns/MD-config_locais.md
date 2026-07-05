# MD-config_locais-colunas — Colunas

## Tabela: `config_locais`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id` | int | NOT NULL AUTO_INCREMENT |
| `id_unidade` | bigint | unsigned NOT NULL |
| `nome` | varchar(100) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL |
| `tipo` | enum('RECEPCAO','TRIAGEM','CONSULTORIO','EXAME','MEDICACAO') | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL |
| `ativo` | tinyint(1) | DEFAULT '1' |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id`),
KEY `fk_config_locais_unidade` (`id_unidade`),
CONSTRAINT `fk_config_locais_unidade` FOREIGN KEY (`id_unidade`) REFERENCES `unidade` (`id_unidade`)
/*!40000 ALTER TABLE `config_locais` DISABLE KEYS */;
/*!40000 ALTER TABLE `config_locais` ENABLE KEYS */;
