# MD-medicacao_reavaliacao-colunas — Colunas

## Tabela: `medicacao_reavaliacao`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_reavaliacao` | bigint | NOT NULL AUTO_INCREMENT |
| `id_fila_medicacao` | bigint | NOT NULL |
| `id_ffa` | bigint | NOT NULL |
| `previsto_em` | datetime | NOT NULL |
| `executado_em` | datetime | DEFAULT NULL |
| `status` | enum('PENDENTE','EM_EXECUCAO','CONCLUIDO','CANCELADO') | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'PENDENTE' |
| `id_sessao_usuario` | bigint | NOT NULL |
| `id_local_operacional` | bigint | DEFAULT NULL |
| `id_usuario_criador` | bigint | NOT NULL |
| `id_usuario_executor` | bigint | DEFAULT NULL |
| `observacao` | text | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci |
| `criado_em` | datetime | NOT NULL DEFAULT CURRENT_TIMESTAMP |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_reavaliacao`),
KEY `idx_reav_fila` (`id_fila_medicacao`,`status`,`previsto_em`),
KEY `idx_reav_ffa` (`id_ffa`,`status`,`previsto_em`),
KEY `fk_reav_sessao` (`id_sessao_usuario`),
KEY `fk_reav_local` (`id_local_operacional`),
KEY `fk_reav_usr_criador` (`id_usuario_criador`),
KEY `fk_reav_usr_exec` (`id_usuario_executor`),
CONSTRAINT `fk_reav_fila` FOREIGN KEY (`id_fila_medicacao`) REFERENCES `fila_operacional` (`id_fila`),
CONSTRAINT `fk_reav_local` FOREIGN KEY (`id_local_operacional`) REFERENCES `local_operacional` (`id_local_operacional`),
CONSTRAINT `fk_reav_usr_criador` FOREIGN KEY (`id_usuario_criador`) REFERENCES `usuario` (`id_usuario`),
CONSTRAINT `fk_reav_usr_exec` FOREIGN KEY (`id_usuario_executor`) REFERENCES `usuario` (`id_usuario`)
/*!40000 ALTER TABLE `medicacao_reavaliacao` DISABLE KEYS */;
/*!40000 ALTER TABLE `medicacao_reavaliacao` ENABLE KEYS */;
