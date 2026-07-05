# MD-permissao-colunas — Colunas

## Tabela: `permissao`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_permissao` | bigint | NOT NULL AUTO_INCREMENT |
| `codigo` | varchar(80) | NOT NULL |
| `nome` | varchar(120) | NOT NULL |
| `dominio` | varchar(40) | DEFAULT 'GERAL' |
| `nome_procedure` | varchar(120) | DEFAULT NULL |
| `acao_frontend` | varchar(80) | DEFAULT NULL |
| `metadata` | json | DEFAULT NULL |
| `criado_em` | datetime(6) | DEFAULT CURRENT_TIMESTAMP(6) |
| `grupo_menu` | varchar(60) | DEFAULT NULL |
| `icone` | varchar(60) | DEFAULT NULL |
| `ordem_menu` | int | DEFAULT NULL |
| `id_entidade` | bigint | unsigned DEFAULT NULL |

---

## Índices

PRIMARY KEY (`id_permissao`),
UNIQUE KEY `uk_permissao_codigo` (`codigo`),
KEY `idx_perm_dominio` (`dominio`),
KEY `idx_perm_ativo` (`ativo`)
/*!40000 ALTER TABLE `permissao` DISABLE KEYS */;
/*!40000 ALTER TABLE `permissao` ENABLE KEYS */;
