# MD-senha_eventos-colunas — Colunas

## Tabela: `senha_eventos`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_evento` | bigint | NOT NULL AUTO_INCREMENT |
| `id_sessao_usuario` | bigint | DEFAULT NULL |
| `id_senha` | bigint | NOT NULL |
| `tipo_evento` | varchar(60) | NOT NULL |
| `status_de` | varchar(50) | DEFAULT NULL |
| `status_para` | varchar(50) | DEFAULT NULL |
| `criado_em` | datetime | NOT NULL DEFAULT CURRENT_TIMESTAMP |
| `id_entidade` | bigint | unsigned DEFAULT NULL |

---

## Índices

PRIMARY KEY (`id_evento`),
KEY `idx_se_senha_criado` (`id_senha`,`criado_em`),
KEY `idx_se_sessao_criado` (`id_sessao_usuario`,`criado_em`),
KEY `idx_se_tipo_criado` (`tipo_evento`,`criado_em`)
/*!40000 ALTER TABLE `senha_eventos` DISABLE KEYS */;
/*!40000 ALTER TABLE `senha_eventos` ENABLE KEYS */;
