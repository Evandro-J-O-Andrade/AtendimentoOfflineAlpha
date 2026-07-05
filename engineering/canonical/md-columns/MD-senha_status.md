# MD-senha_status-colunas — Colunas

## Tabela: `senha_status`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_senha_status` | bigint | NOT NULL AUTO_INCREMENT |
| `codigo` | varchar(30) | NOT NULL |
| `descricao` | varchar(150) | NOT NULL |
| `ativo` | tinyint(1) | DEFAULT '1' |
| `ordem_fluxo` | int | NOT NULL |
| `id_entidade` | bigint | unsigned DEFAULT NULL |

---

## Índices

PRIMARY KEY (`id_senha_status`),
UNIQUE KEY `uk_senha_status_codigo` (`codigo`)
/*!40000 ALTER TABLE `senha_status` DISABLE KEYS */;
/*!40000 ALTER TABLE `senha_status` ENABLE KEYS */;
