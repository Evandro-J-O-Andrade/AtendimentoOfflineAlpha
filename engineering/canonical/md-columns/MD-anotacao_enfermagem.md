# MD-anotacao_enfermagem-colunas — Colunas

## Tabela: `anotacao_enfermagem`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_anotacao` | bigint | NOT NULL AUTO_INCREMENT |
| `id_internacao` | bigint | NOT NULL |
| `descricao` | text | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL |
| `id_usuario` | bigint | NOT NULL |
| `data_hora` | datetime | DEFAULT CURRENT_TIMESTAMP |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_anotacao`),
KEY `id_internacao` (`id_internacao`),
KEY `id_usuario` (`id_usuario`),
CONSTRAINT `anotacao_enfermagem_ibfk_1` FOREIGN KEY (`id_internacao`) REFERENCES `internacao` (`id_internacao`),
CONSTRAINT `anotacao_enfermagem_ibfk_2` FOREIGN KEY (`id_usuario`) REFERENCES `usuario` (`id_usuario`)
/*!40000 ALTER TABLE `anotacao_enfermagem` DISABLE KEYS */;
/*!40000 ALTER TABLE `anotacao_enfermagem` ENABLE KEYS */;
