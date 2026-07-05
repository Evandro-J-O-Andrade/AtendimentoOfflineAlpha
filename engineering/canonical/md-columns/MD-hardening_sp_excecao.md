# MD-hardening_sp_excecao-colunas — Colunas

## Tabela: `hardening_sp_excecao`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `sp_nome` | varchar(128) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL |
| `motivo` | varchar(255) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL |
| `criado_em` | datetime | NOT NULL DEFAULT CURRENT_TIMESTAMP |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`sp_nome`)
/*!40000 ALTER TABLE `hardening_sp_excecao` DISABLE KEYS */;
/*!40000 ALTER TABLE `hardening_sp_excecao` ENABLE KEYS */;
