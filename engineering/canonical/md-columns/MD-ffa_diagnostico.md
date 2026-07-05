# MD-ffa_diagnostico-colunas — Colunas

## Tabela: `ffa_diagnostico`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_diagnostico` | bigint | NOT NULL AUTO_INCREMENT |
| `id_ffa` | bigint | NOT NULL |
| `id_sessao_usuario` | bigint | NOT NULL |
| `id_usuario` | bigint | NOT NULL |
| `cid10` | varchar(12) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL |
| `descricao` | varchar(255) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL |
| `tipo` | enum('PRINCIPAL','SECUNDARIO','SUSPEITA') | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'PRINCIPAL' |
| `observacao` | text | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci |
| `criado_em` | datetime | NOT NULL DEFAULT CURRENT_TIMESTAMP |
| `atualizado_em` | datetime | DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_diagnostico`),
UNIQUE KEY `ux_diag_ffa_cid_tipo` (`id_ffa`,`cid10`,`tipo`),
KEY `idx_diag_ffa` (`id_ffa`),
KEY `idx_diag_sessao` (`id_sessao_usuario`),
KEY `fk_diag_usuario` (`id_usuario`),
CONSTRAINT `fk_diag_usuario` FOREIGN KEY (`id_usuario`) REFERENCES `usuario` (`id_usuario`)
/*!40000 ALTER TABLE `ffa_diagnostico` DISABLE KEYS */;
/*!40000 ALTER TABLE `ffa_diagnostico` ENABLE KEYS */;
