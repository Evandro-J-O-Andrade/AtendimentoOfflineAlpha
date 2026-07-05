# MD-enfermagem-colunas — Colunas

## Tabela: `enfermagem`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_usuario` | bigint | NOT NULL |
| `coren` | varchar(20) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL |
| `uf_coren` | char(2) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL |
| `tipo` | enum('ENFERMEIRO','TECNICO') | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_usuario`),
UNIQUE KEY `uk_coren` (`coren`,`uf_coren`),
CONSTRAINT `enfermagem_ibfk_1` FOREIGN KEY (`id_usuario`) REFERENCES `usuario` (`id_usuario`)
/*!40000 ALTER TABLE `enfermagem` DISABLE KEYS */;
/*!40000 ALTER TABLE `enfermagem` ENABLE KEYS */;
