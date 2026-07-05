# MD-interconsulta-colunas — Colunas

## Tabela: `interconsulta`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_interconsulta` | bigint | NOT NULL AUTO_INCREMENT |
| `id_internacao` | bigint | DEFAULT NULL |
| `id_especialidade` | bigint | DEFAULT NULL |
| `status` | enum('SOLICITADA','RESPONDIDA') | DEFAULT 'SOLICITADA' |
| `data_hora` | datetime | DEFAULT CURRENT_TIMESTAMP |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_interconsulta`),
KEY `fk_interconsulta_especialidade` (`id_especialidade`),
CONSTRAINT `fk_interconsulta_especialidade` FOREIGN KEY (`id_especialidade`) REFERENCES `especialidade` (`id_especialidade`) ON DELETE RESTRICT ON UPDATE CASCADE
/*!40000 ALTER TABLE `interconsulta` DISABLE KEYS */;
/*!40000 ALTER TABLE `interconsulta` ENABLE KEYS */;
