# MD-ffa_evolucao-colunas — Colunas

## Tabela: `ffa_evolucao`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_evolucao` | bigint | NOT NULL AUTO_INCREMENT |
| `id_ffa` | bigint | NOT NULL |
| `id_sessao_usuario` | bigint | NOT NULL |
| `id_usuario` | bigint | NOT NULL |
| `criado_em` | datetime | DEFAULT CURRENT_TIMESTAMP |
| `tipo` | varchar(30) | NOT NULL DEFAULT 'EVOLUCAO' |
| `modulo` | varchar(60) | DEFAULT NULL |
| `id_local_operacional` | bigint | DEFAULT NULL |
| `ip` | varchar(60) | DEFAULT NULL |
| `user_agent` | varchar(255) | DEFAULT NULL |
| `hash_integridade` | varchar(64) | DEFAULT NULL |
| `atualizado_em` | datetime | DEFAULT NULL |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_evolucao`),
KEY `idx_evo_ffa` (`id_ffa`),
KEY `idx_evo_sessao` (`id_sessao_usuario`),
KEY `idx_evo_usuario` (`id_usuario`),
CONSTRAINT `fk_evo_usuario` FOREIGN KEY (`id_usuario`) REFERENCES `usuario` (`id_usuario`)
/*!40000 ALTER TABLE `ffa_evolucao` DISABLE KEYS */;
/*!40000 ALTER TABLE `ffa_evolucao` ENABLE KEYS */;
