# MD-setor-colunas — Colunas

## Tabela: `setor`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_setor` | int | NOT NULL AUTO_INCREMENT |
| `id_unidade` | bigint | unsigned NOT NULL |
| `nome` | varchar(100) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL |
| `tipo` | enum('PRONTO_SOCORRO','OBSERVACAO','INTERNACAO','UTI_ADULTO','UTI_PEDIATRICA','CENTRO_CIRURGICO') | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL |
| `ramal` | varchar(10) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL |
| `responsavel_id` | bigint | DEFAULT NULL |
| `ativo` | tinyint(1) | DEFAULT '1' |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_setor`),
KEY `fk_setor_unidade` (`id_unidade`),
CONSTRAINT `fk_setor_unidade` FOREIGN KEY (`id_unidade`) REFERENCES `unidade` (`id_unidade`)
/*!40000 ALTER TABLE `setor` DISABLE KEYS */;
/*!40000 ALTER TABLE `setor` ENABLE KEYS */;
