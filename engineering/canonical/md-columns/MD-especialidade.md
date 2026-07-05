# MD-especialidade-colunas — Colunas

## Tabela: `especialidade`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_especialidade` | bigint | NOT NULL AUTO_INCREMENT |
| `nome` | varchar(150) | NOT NULL |
| `cbo` | varchar(10) | DEFAULT NULL |
| `criado_em` | datetime(6) | DEFAULT CURRENT_TIMESTAMP(6) |
| `atualizado_em` | datetime(6) | DEFAULT NULL |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_especialidade`),
UNIQUE KEY `nome` (`nome`)
/*!40000 ALTER TABLE `especialidade` DISABLE KEYS */;
/*!40000 ALTER TABLE `especialidade` ENABLE KEYS */;
