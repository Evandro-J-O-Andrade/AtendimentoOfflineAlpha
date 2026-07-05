# MD-exame_fisico-colunas — Colunas

## Tabela: `exame_fisico`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_exame` | bigint | NOT NULL AUTO_INCREMENT |
| `id_atendimento` | bigint | unsigned NOT NULL |
| `descricao` | text | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci |
| `id_usuario` | bigint | DEFAULT NULL |
| `data_hora` | datetime | DEFAULT CURRENT_TIMESTAMP |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_exame`),
KEY `id_atendimento` (`id_atendimento`),
KEY `id_usuario` (`id_usuario`),
CONSTRAINT `exame_fisico_ibfk_2` FOREIGN KEY (`id_usuario`) REFERENCES `usuario` (`id_usuario`)
/*!40000 ALTER TABLE `exame_fisico` DISABLE KEYS */;
/*!40000 ALTER TABLE `exame_fisico` ENABLE KEYS */;
