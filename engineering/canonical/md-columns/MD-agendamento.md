# MD-agendamento-colunas — Colunas

## Tabela: `agendamento`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_agendamento` | bigint | NOT NULL AUTO_INCREMENT |
| `id_sistema` | bigint | NOT NULL |
| `id_unidade` | bigint | unsigned DEFAULT NULL |
| `id_local_operacional` | bigint | DEFAULT NULL |
| `id_profissional` | bigint | DEFAULT NULL |
| `id_paciente` | bigint | DEFAULT NULL |
| `id_ffa` | bigint | unsigned DEFAULT NULL |
| `id_senha` | bigint | unsigned DEFAULT NULL |
| `id_servico` | bigint | NOT NULL |
| `inicio_em` | datetime(6) | NOT NULL |
| `fim_em` | datetime(6) | NOT NULL |
| `duracao_minutos` | int | GENERATED ALWAYS AS (timestampdiff(MINUTE |
| `status` | varchar(40) | CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL |
| `origem` | varchar(40) | CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL |
| `observacao` | text | CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci |
| `criado_em` | datetime(6) | NOT NULL DEFAULT CURRENT_TIMESTAMP(6) |
| `atualizado_em` | datetime(6) | DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP(6) |
| `criado_por` | bigint | NOT NULL |
| `id_sessao_criacao` | bigint | DEFAULT NULL |
| `uuid_sync` | char(36) | CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL |
| `versao_sync` | bigint | DEFAULT '0' |
| `hash_estado` | char(64) | CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_agendamento`),
KEY `idx_ag_prof` (`id_profissional`,`inicio_em`),
KEY `idx_ag_local` (`id_local_operacional`,`inicio_em`),
KEY `idx_ag_paciente` (`id_paciente`,`inicio_em`),
KEY `idx_ag_ffa` (`id_ffa`,`inicio_em`),
KEY `idx_ag_senha` (`id_senha`),
KEY `idx_ag_ctx_inicio` (`id_sistema`,`id_unidade`,`inicio_em`),
KEY `fk_ag_servico` (`id_servico`),
KEY `fk_ag_sessao` (`id_sessao_criacao`),
KEY `fk_ag_unidade` (`id_unidade`),
KEY `fk_agendamento_entidade` (`id_entidade`),
CONSTRAINT `fk_ag_paciente` FOREIGN KEY (`id_paciente`) REFERENCES `paciente` (`id`),
CONSTRAINT `fk_ag_prof` FOREIGN KEY (`id_profissional`) REFERENCES `usuario` (`id_usuario`),
CONSTRAINT `fk_ag_servico` FOREIGN KEY (`id_servico`) REFERENCES `servico_agendamento` (`id_servico`),
CONSTRAINT `fk_ag_sistema` FOREIGN KEY (`id_sistema`) REFERENCES `sistema` (`id_sistema`),
CONSTRAINT `fk_agendamento_entidade` FOREIGN KEY (`id_entidade`) REFERENCES `saas_entidade` (`id_entidade`),
CONSTRAINT `fk_agendamento_ffa` FOREIGN KEY (`id_ffa`) REFERENCES `ffa` (`id_ffa`),
CONSTRAINT `fk_agendamento_senha` FOREIGN KEY (`id_senha`) REFERENCES `senha` (`id_senha`),
CONSTRAINT `fk_agendamento_unidade` FOREIGN KEY (`id_unidade`) REFERENCES `unidade` (`id_unidade`)
/*!40000 ALTER TABLE `agendamento` DISABLE KEYS */;
/*!40000 ALTER TABLE `agendamento` ENABLE KEYS */;
