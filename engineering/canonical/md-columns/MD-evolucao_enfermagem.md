# MD-evolucao_enfermagem-colunas — Colunas

## Tabela: `evolucao_enfermagem`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_evolucao` | bigint | NOT NULL AUTO_INCREMENT |
| `id_internacao` | bigint | NOT NULL |
| `descricao` | text | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL |
| `id_enfermeiro` | bigint | NOT NULL |
| `data_hora` | datetime | DEFAULT CURRENT_TIMESTAMP |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_evolucao`),
KEY `id_internacao` (`id_internacao`),
KEY `id_enfermeiro` (`id_enfermeiro`),
CONSTRAINT `evolucao_enfermagem_ibfk_1` FOREIGN KEY (`id_internacao`) REFERENCES `internacao` (`id_internacao`),
CONSTRAINT `evolucao_enfermagem_ibfk_2` FOREIGN KEY (`id_enfermeiro`) REFERENCES `usuario` (`id_usuario`)
/*!40000 ALTER TABLE `evolucao_enfermagem` DISABLE KEYS */;
/*!40000 ALTER TABLE `evolucao_enfermagem` ENABLE KEYS */;
