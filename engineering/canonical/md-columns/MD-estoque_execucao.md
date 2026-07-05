# MD-estoque_execucao-colunas — Colunas

## Tabela: `estoque_execucao`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `hash_execucao` | char(64) | NOT NULL |
| `id_sessao_usuario` | bigint | NOT NULL |
| `contexto_operacional` | varchar(100) | NOT NULL |
| `criado_em` | datetime | NOT NULL DEFAULT CURRENT_TIMESTAMP |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`hash_execucao`)
/*!40000 ALTER TABLE `estoque_execucao` DISABLE KEYS */;
/*!40000 ALTER TABLE `estoque_execucao` ENABLE KEYS */;
